extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerCursor.enable_cursor(false)

func _on_yaya_game_end() -> void:
	PlayerCursor.enable_cursor(true)
	GlobalScript.change_scene(GlobalScript.Kitchen01)
