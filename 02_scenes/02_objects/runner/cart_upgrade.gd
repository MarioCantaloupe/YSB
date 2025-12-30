extends Node2D

@export var obstacle_data : Resource
@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	sprite.texture = obstacle_data.sprite

func _physics_process(_delta: float) -> void:
	position.x -= obstacle_data.movement_speed

func _on_collision_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		area.get_parent().get_parent().increase_carrito_level(1)
		queue_free()
