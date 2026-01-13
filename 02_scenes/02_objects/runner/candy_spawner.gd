extends Node2D

@onready var player: Player = %YayaPlayer

@export var candy_scene : PackedScene = preload("res://02_scenes/02_objects/runner/cart_upgrade.tscn")


func _on_asteroid_spawn_timer_timeout() -> void:
	if player.carrito_demon:
		return
	
	var candy = candy_scene.instantiate()
	candy.position.y = randi_range(0 , get_viewport().size.y - 100)
	candy.position.x = get_viewport().size.x + 100
	add_child(candy)
