extends Node2D

@export var max_sound_count : int = 128

var sound_count : int

var _music_player : AudioStreamPlayer2D = null

enum Bus {
	Master,
	Music,
	SFX,
	UI,
}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func play_music(music: AudioStream, volumeDb):
	if _music_player:
		stop_music()

	_music_player = AudioStreamPlayer2D.new()
	_music_player.process_mode = Node.PROCESS_MODE_ALWAYS
	_music_player.stream = music
	_music_player.volume_db = volumeDb
	_music_player.bus = "Music"
	add_child(_music_player)
	_music_player.play()

func stop_music() -> void:
	if _music_player:
		_music_player.stop()
		_music_player.queue_free()
		_music_player = null

func play_oneshot(sound: AudioStream, volume_db : float, pitch_scale : float, panning_strength: float, bus : Bus) -> void:
	if sound_count < max_sound_count:
		var audio_player = AudioStreamPlayer2D.new()
		audio_player.process_mode = Node.PROCESS_MODE_ALWAYS
		sound_count += 1
		
		# sound settings
		audio_player.bus = Bus.keys()[bus]
		audio_player.volume_db = volume_db
		audio_player.pitch_scale = pitch_scale
		audio_player.panning_strength = panning_strength
		audio_player.stream = sound
		
		
		# adding player
		await get_tree().process_frame
		add_child(audio_player)
		audio_player.play()
		audio_player.connect("finished", Callable(self, "_on_finished").bind(audio_player)) #borrar y reducir cuenta

func _on_finished(player: AudioStreamPlayer2D) -> void:
	sound_count -= 1
	player.queue_free()
