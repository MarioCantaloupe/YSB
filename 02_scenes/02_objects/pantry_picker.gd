extends Button

@export var item_resource : Resource
var item_scene = preload("res://02_scenes/02_objects/item.tscn")
const WORLD_NODE_PATH := NodePath("") 

func _on_button_down() -> void:
	if PlayerCursor.held_item != null:
		return
	
	var new_item = item_scene.instantiate()
	new_item.food_data = item_resource
	
	# Add it to the *world* (not the UI)
	var world_parent: Node = null
	if WORLD_NODE_PATH != NodePath(""):
		if get_tree().current_scene.has_node(WORLD_NODE_PATH):
			world_parent = get_tree().current_scene.get_node(WORLD_NODE_PATH)
		else:
			push_error("WORLD_NODE_PATH does not exist; adding to current_scene root instead.")
	if world_parent == null:
		world_parent = get_tree().current_scene

	world_parent.add_child(new_item)

	# Place it where the mouse is in global (world) coordinates.
	# Use the item's own Node2D helper to get the right canvas position:
	new_item.global_position = new_item.get_global_mouse_position()

	# Simulate the normal pickup behavior so it behaves exactly like clicking an existing item
	# (this method exists in your item script)
	if new_item.has_method("_on_click_area_button_down"):
		new_item._on_click_area_button_down()
	else:
		# fallback: ensure it's selected and frozen so it doesn't fall
		if new_item.has_variable("selected"):
			new_item.selected = true
		if new_item.has_variable("freeze"):
			new_item.freeze = true
	
	
