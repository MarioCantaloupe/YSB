extends DynamicButton
class_name SceneChanger

@export var target_scene_path : String
@export var transition : SceneLoader.Transition = SceneLoader.Transition.FADE
@export var use_loading_screen : bool = true

func _ready() -> void:
	super._ready()
	pressed.connect(_change_scene)

func _change_scene() -> void:
	if PlayerCursor.is_knife or PlayerCursor.is_holding:
		return
	
	SceneLoader.load_scene(target_scene_path, transition, use_loading_screen)
