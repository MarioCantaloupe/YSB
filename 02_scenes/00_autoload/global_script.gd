extends Node

var Kitchen01 = "res://02_scenes/03_levels/debug.tscn"


func wait(duration):  
	await get_tree().create_timer(duration, false, false, true).timeout

func change_scene(scene):
	get_tree().change_scene_to_file(scene)

func play_sound_once(stream: AudioStream) -> void:
	var p = AudioStreamPlayer.new()
	p.stream = stream
	add_child(p)
	p.play()
	p.finished.connect(p.queue_free)
