extends Node2D

signal loot_generated(amount: int, world_position: Vector2)

@export var obstacle_data : ObstacleData

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
		if area.owner.carrito_demon:
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
	var amount : int = give_loot()
	emit_signal("loot_generated", amount, global_position)
	queue_free()

func give_loot() -> int:
	var pool := PantryInventory.get_all_item_data()
	if pool.is_empty():
		push_error("Inventory pool empty")
		return 0 
	
	var amount : int = generate_loot_amount()
	
	for i in amount:
		var item_data: ItemData = pool.pick_random()
		if item_data == null:
			continue
		
		var state : ItemState = ItemState.new()
		state.data = item_data
		state.is_clean = false
		state.is_frozen = randf_range(0,1)
		
		PantryInventory.add_item_state(state)
	
	return amount

func generate_loot_amount() -> int:
	var amount := randi_range(
		obstacle_data.min_loot,
		obstacle_data.max_loot
	)

	if obstacle_data.size_variance != 0.0:
		var variance := randf_range(-obstacle_data.size_variance, obstacle_data.size_variance)
		amount = int(round(amount * (1.0 + variance)))

	return max(amount, 1)
