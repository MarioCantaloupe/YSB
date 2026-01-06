extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameSystem.game_started = false



func _on_button_options_pressed() -> void:
	var options = preload("res://02_scenes/04_screens/screen_options.tscn").instantiate()
	get_tree().root.add_child(options)
	
	options.exited.connect(func():
		options.queue_free()
)
