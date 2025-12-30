extends Node2D

var progress := []
var target_scene : String

func _ready() -> void:
	target_scene = get_tree().get_meta("target_scene", "")
	ResourceLoader.load_threaded_request(target_scene)

func _process(_delta: float) -> void:
	var status = ResourceLoader.load_threaded_get_status(target_scene, progress)

	# update progress bar here (progress[0])

	if status == ResourceLoader.THREAD_LOAD_LOADED:
		var packed = ResourceLoader.load_threaded_get(target_scene)
		get_tree().change_scene_to_packed(packed)
