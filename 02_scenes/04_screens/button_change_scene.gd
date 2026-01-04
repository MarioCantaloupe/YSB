extends DynamicButton

@export var target_scene_path : String
@export var transition : SceneLoader.Transition = SceneLoader.Transition.FADE
@export var use_loading_screen : bool = true

func _on_pressed() -> void:
	if PlayerCursor.is_knife or PlayerCursor.is_holding:
		return
	
	SceneLoader.load_scene(target_scene_path, transition, use_loading_screen)
