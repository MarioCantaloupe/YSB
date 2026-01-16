extends Node2D

@onready var player: Player = %YayaPlayer

@export var candy_scene : PackedScene = preload("res://02_scenes/02_objects/runner/cart_upgrade.tscn")


func _on_asteroid_spawn_timer_timeout() -> void:
	if player.carrito_demon:
		return
	
	var candy : Node2D = candy_scene.instantiate()
	candy.global_position.y =  randi_range(0 , get_viewport().size.y - 100)
	candy.global_position.x = get_viewport().size.x + 100
	add_child(candy)
	print_debug("spawned candy!")
