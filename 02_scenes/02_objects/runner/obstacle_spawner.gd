extends Node2D

@export var obstacle_scenes := [
	{ "scene": preload("res://02_scenes/02_objects/runner/obstacle.tscn"), "weight": 3 },
	{ "scene": preload("res://02_scenes/02_objects/runner/cart_upgrade.tscn"), "weight": 1 },
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_asteroid_spawn_timer_timeout() -> void:
	var scene = pick_weighted_scene()
	var obstacle = scene.instantiate()
	obstacle.position.y = randi_range(0 , get_viewport().size.y - 50)
	obstacle.position.x = get_viewport().size.x + 100
	add_child(obstacle)
	
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
