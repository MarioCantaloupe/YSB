extends Button


@export var target_scene : String
	
func _pressed() -> void:
	GlobalScript.change_scene(target_scene)
