extends Control

@onready var music_player: AudioStreamPlayer2D = $MusicPlayer
@onready var sync_audio_stream : AudioStreamSynchronized = music_player.stream

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameSystem.game_started = false
	GameSystem.music_started = false
	music_player.play()

func _on_button_options_pressed() -> void:
	sync_audio_stream.set_sync_stream_volume(2, -24)
	sync_audio_stream.set_sync_stream_volume(0, -6)
	var options = preload("res://02_scenes/04_screens/screen_options.tscn").instantiate()
	get_tree().root.add_child(options)
	
	options.exited.connect(func():
		options.queue_free()
		sync_audio_stream.set_sync_stream_volume(2, 0)
		sync_audio_stream.set_sync_stream_volume(0, 0)
)
