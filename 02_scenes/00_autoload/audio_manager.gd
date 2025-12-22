extends Node2D
class_name AudioManager

@export var max_sound_count : int = 128
var test_sound = preload("res://01_assets/03_sound/Boing-001.wav")
var test_music = preload("res://01_assets/03_sound/music/doodoo.mp3")

var sound_count : int

var _music_player : AudioStreamPlayer2D = null

enum Bus {
	Master,
	Music,
	SFX,
	UI,
}

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_key"):
		play_oneshot(test_sound, 0, 2, 0, AudioManager.Bus.SFX)
		if not _music_player:
			play_music(test_music)
		else:
			stop_music()
func play_music(music: AudioStream):
	if _music_player:
		stop_music()

	_music_player = AudioStreamPlayer2D.new()
	_music_player.stream = music
	_music_player.bus = "Music"
	get_tree().current_scene.add_child(_music_player)
	_music_player.play()

func stop_music() -> void:
	if _music_player:
		_music_player.stop()
		_music_player.queue_free()
		_music_player = null

func play_oneshot(sound: AudioStream, volume_db : float, pitch_scale : float, panning_strength: float, bus : Bus) -> void:
	if sound_count < max_sound_count:
		var audio_player = AudioStreamPlayer2D.new()
		sound_count += 1
		
		# sound settings
		audio_player.bus = Bus.keys()[bus]
		audio_player.volume_db = volume_db
		audio_player.pitch_scale = pitch_scale
		audio_player.panning_strength = panning_strength
		audio_player.stream = sound
		
		
		# adding player
		get_tree().current_scene.add_child(audio_player)
		audio_player.play()
		audio_player.connect("finished", Callable(self, "_on_finished").bind(audio_player)) #borrar y reducir cuenta

func _on_finished(player: AudioStreamPlayer2D) -> void:
	# Called when the finished signal is emitted
	sound_count -= 1
	player.queue_free()
