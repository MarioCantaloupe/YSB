extends Node2D


@export var obstacle_data : Resource

@export var obstacle_particles_scene: PackedScene

@onready var sprite: Sprite2D = $sprite

var instanced_particles = null
var random_rotation : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	random_rotation = randf_range(-0.05, 0.05)
	sprite.texture = obstacle_data.sprite
	instanced_particles = obstacle_particles_scene.instantiate()
	await instanced_particles.ready
	
	
func _physics_process(_delta: float) -> void:
	position.x -= obstacle_data.movement_speed
	rotation += random_rotation

func _on_collision_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		if area.get_parent().get_parent().carrito_demon:
			destroyed()
		else:
			pass

func destroyed():
	if obstacle_particles_scene:
		var particles = instanced_particles
		particles.obstacle_texture = obstacle_data.sprite
		particles.global_position = global_position
		get_parent().add_child(particles)
		particles.emitting = true
		
		# play sound
		var audio_player = AudioStreamPlayer2D.new() #crear sonido de explosion
		audio_player.volume_db = 0
		audio_player.stream = obstacle_data.hit_sound
		get_tree().current_scene.add_child(audio_player)
		audio_player.play()
		audio_player.connect("finished", Callable(audio_player, "queue_free")) #se auto borra el sonido
		
		# Clean up particles after they finish
		var particle_timer := Timer.new()
		particle_timer.wait_time = particles.lifetime
		particle_timer.one_shot = true
		particle_timer.connect("timeout", Callable(particles, "queue_free"))
		get_parent().add_child(particle_timer)
		particle_timer.start()
		
		
	else:
		push_error("no obstacle particles found")
	# TODO: drop loot
	queue_free()
