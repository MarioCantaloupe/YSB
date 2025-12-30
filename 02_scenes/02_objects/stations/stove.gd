extends Node2D

@onready var fire_sprite: Sprite2D = $fire_sprite


func _on_station_station_selected(state : bool) -> void:
	if state:
		fire_sprite.show()
	else:
		fire_sprite.hide()
