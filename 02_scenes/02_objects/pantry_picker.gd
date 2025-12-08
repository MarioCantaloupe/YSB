extends Button

signal item_dropped(item)

@export var item_resource : Resource
var item_scene = preload("res://02_scenes/02_objects/item.tscn")
const WORLD_NODE_PATH := NodePath("") 

var can_drop : bool = false

func _ready() -> void:
	button_down.connect(_on_button_down)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

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
	if new_item.has_method("_on_click_area_input_event"):
		new_item._on_click_area_input_event(null, null, 0)
	else:
		# fallback: ensure it's selected and frozen so it doesn't fall
		if new_item.has_variable("selected"):
			new_item.selected = true
		if new_item.has_variable("freeze"):
			new_item.freeze = true

func _process(_delta: float) -> void:
	if Input.is_action_just_released("Lclick"):
		if can_drop and PlayerCursor.held_item != null:
			print("item dropped")
			emit_signal("item_dropped", PlayerCursor.held_item)
			PlayerCursor.held_item.queue_free()

func _on_mouse_entered() -> void:
	can_drop = true
	print(can_drop)

func _on_mouse_exited() -> void:
	can_drop = false
	print(can_drop)
