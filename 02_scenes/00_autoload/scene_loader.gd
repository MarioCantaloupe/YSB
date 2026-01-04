extends Node

enum Transition {
	NONE,
	FADE,
	SLIDE_LEFT,
	SLIDE_RIGHT
}

@export var loading_scene_path := "res://02_scenes/04_screens/screen_loading.tscn"

var _target_scene : String
var _transition : Transition = Transition.FADE
var _use_loading_screen := true



func load_scene(scene_path : String, transition : Transition = Transition.FADE, use_loading_screen : bool = true) -> void:
	_target_scene = scene_path
	_transition = transition
	_use_loading_screen = use_loading_screen
	for item in get_tree().get_nodes_in_group("Item"):
			var state : ItemState = item.save_item_state()
			PantryInventory.add_item_state(state)
			print("added " + str(state) + "to inventory")
			play_item_exit_animation()
	if _transition == Transition.NONE:
		_change_scene()
	else:
		_play_transition_out()
	

func _change_scene() -> void:
	if _use_loading_screen:
		get_tree().set_meta("target_scene", _target_scene)
		get_tree().set_meta("transition", _transition)
		get_tree().change_scene_to_file(loading_scene_path)
	else:
		get_tree().change_scene_to_file(_target_scene)

	# Defer so the new scene is fully ready
	call_deferred("_play_transition_in")

func _create_transition_overlay() -> CanvasLayer:
	var scene = preload("res://02_scenes/04_screens/transition_overlay.tscn")
	return scene.instantiate()


func _play_transition_in() -> void:
	if _transition == Transition.NONE:
		return

	var overlay := _create_transition_overlay()
	add_child(overlay)

	match _transition:
		Transition.FADE:
			overlay.fade_in()
		Transition.SLIDE_LEFT, Transition.SLIDE_RIGHT:
			overlay.slide_in(_transition)


func _play_transition_out() -> void:
	var overlay := _create_transition_overlay()
	add_child(overlay)

	match _transition:
		Transition.FADE:
			overlay.fade_out(_change_scene)
		Transition.SLIDE_LEFT, Transition.SLIDE_RIGHT:
			overlay.slide_out(_transition, _change_scene)

func _go_to_loading_screen() -> void:
	get_tree().set_meta("target_scene", _target_scene)
	get_tree().change_scene_to_file(loading_scene_path)


# TODO: change globalscript to sceneloader singleton
#func change_scene(scene):
	#get_tree().change_scene_to_file(scene)

func play_item_exit_animation() -> void:
	var items := get_tree().get_nodes_in_group("Item")
	if items.is_empty():
		print_debug("tree doesn't have items")
		return

	var target : Vector2 = Vector2(
		DisplayServer.screen_get_size().x/3.0,
			DisplayServer.screen_get_size().y-100.0)
	var longest_tween: Tween = null

	for item : Item in items:
		var tween : Tween = item.animate_to_inventory(target)
		longest_tween = tween

	if longest_tween:
		await longest_tween.finished
