extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameSystem.game_started = false
	AudioManager.play_music(preload("res://01_assets/03_sound/music/menu_theme.mp3"))


func _on_button_options_pressed() -> void:
	var options = preload("res://02_scenes/04_screens/screen_options.tscn").instantiate()
	get_tree().root.add_child(options)
	
	options.exited.connect(func():
		options.queue_free()
)

func _exit_tree():
	AudioManager.stop_music()
