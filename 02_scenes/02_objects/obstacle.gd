extends Node2D


@export var obstacle_data : Resource

@export var obstacle_particles_scene: PackedScene

@onready var sprite: Sprite2D = $sprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.texture = obstacle_data.sprite

func _physics_process(_delta: float) -> void:
	position.x -= obstacle_data.movement_speed

func _on_collision_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		if area.get_parent().carrito_demon:
			destroyed()
		else:
			pass

func destroyed():
	if obstacle_particles_scene:
		var particles = obstacle_particles_scene.instantiate()
		
		particles.global_position = global_position
		#get_parent().add_child(particles)
		particles.emitting = true

		# Clean up particles after they finish
		var particle_timer := Timer.new()
		particle_timer.wait_time = particles.lifetime
		particle_timer.one_shot = true
		particle_timer.connect("timeout", Callable(particles, "queue_free"))
		get_parent().add_child(particle_timer)
		particle_timer.start()
	# TODO: drop loot
	queue_free()
