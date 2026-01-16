extends Node2D

@onready var fire_sprite: Sprite2D = $fire_sprite
@onready var audio_player: AudioStreamPlayer2D = $AudioPlayer

func _on_station_station_selected(state : bool, _item : Item) -> void:
	if state:
		fire_sprite.show()
		print_debug("stove ON")
		audio_player.play()
		audio_player.pitch_scale = randf_range(0.95,1.05)
	else:
		fire_sprite.hide()
		print_debug("stove OFF")
		audio_player.stop()
