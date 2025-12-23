extends Button

@export var target_scene_path : String



func _on_pressed() -> void:
	get_tree().change_scene_to_file(target_scene_path)
	print("Changing scene to " + str(target_scene_path))
