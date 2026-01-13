extends Node2D

@onready var player: Player = %YayaPlayer

@export var number_visFeedback_scene : PackedScene

@export var obstacle_scenes := [
	{
		"scene": preload("res://02_scenes/02_objects/runner/obstacle.tscn"),
		"weight": 3,
		"is_obstacle": true
	},
	{
		"scene": preload("res://02_scenes/02_objects/runner/obstacle_variants/obstacle_rock.tscn"),
		"weight": 10,
		"is_obstacle": true
	},
	{
		"scene": preload("res://02_scenes/02_objects/runner/obstacle_variants/obstacle_bus.tscn"),
		"weight": 7,
		"is_obstacle": true
	},
	{
		"scene": preload("res://02_scenes/02_objects/runner/obstacle_variants/obstacle_cat.tscn"),
		"weight": 1,
		"is_obstacle": true
	},
	{
		"scene": preload("res://02_scenes/02_objects/runner/obstacle_variants/obstacle_patinete.tscn"),
		"weight": 5,
		"is_obstacle": true
	},
	{
		"scene": preload("res://02_scenes/02_objects/runner/obstacle_variants/obstacle_bici.tscn"),
		"weight": 5,
		"is_obstacle": true
	},
]

@export var obstacle_data_pool : Array[ObstacleData]

@export var scale_variation : float = 0


func _on_asteroid_spawn_timer_timeout() -> void:
	var scene = pick_weighted_scene()
	var obstacle = scene.instantiate()
	obstacle.position.y = randi_range(0 , get_viewport().size.y - 100)
	obstacle.position.x = get_viewport().size.x + 100
	var scale_variance = 1 + randf_range(-obstacle.obstacle_data.size_variance, obstacle.obstacle_data.size_variance)
	if obstacle.get_child(1).is_in_group("space_obstacle"):
		obstacle.scale.x *= scale_variance
		obstacle.scale.y *= scale_variance
	add_child(obstacle)
	if not obstacle.has_method("loot_generated"):
		return
		
	obstacle.loot_generated.connect(_on_obstacle_loot_generated)
	
func pick_weighted_scene() -> PackedScene:
	var total_weight = 0
	for item in obstacle_scenes:
		total_weight += item.weight
	
	var choice = randi() % total_weight
	for item in obstacle_scenes:
		choice -= item.weight
		if choice < 0:
			return item.scene

	return obstacle_scenes[0].scene # Fallback

func _on_obstacle_loot_generated(amount: int, pos: Vector2):
	if amount <= 0:
		return

	var text := number_visFeedback_scene.instantiate()
	text.global_position = pos
	add_child(text)
	text.setup(amount)
