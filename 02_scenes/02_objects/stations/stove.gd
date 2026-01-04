extends Node2D

@onready var fire_sprite: Sprite2D = $fire_sprite


func _on_station_station_selected(state : bool, item : Item) -> void:
	if state:
		fire_sprite.show()
		print_debug("stove ON")
	else:
		fire_sprite.hide()
		print_debug("stove OFF")
