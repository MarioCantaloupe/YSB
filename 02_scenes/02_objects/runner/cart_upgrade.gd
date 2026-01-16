extends Node2D

@export var obstacle_data : Resource
@onready var sprite: Sprite2D = $Sprite2D

@export var upgrade_sound : AudioStream

func _ready() -> void:
	sprite.texture = obstacle_data.sprite

func _physics_process(_delta: float) -> void:
	position.x -= obstacle_data.movement_speed

func _on_collision_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		area.owner.increase_carrito_level(1)
		AudioManager.play_oneshot(upgrade_sound, 0, 1, 0, AudioManager.Bus.SFX)
		queue_free()
