extends Button

signal item_dropped(item)
@onready var inventory_node := get_owner()

@export var item_resource : Resource
var item_scene = preload("res://02_scenes/02_objects/item.tscn")
const WORLD_NODE_PATH := NodePath("") 
#var inventory_root = get_tree().get_current_scene()  


var can_drop : bool = false

func _ready() -> void:
	button_down.connect(_on_button_down)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	icon = item_resource.sprite_grid[0][0]
	expand_icon = true
	icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	text = item_resource.name

func _on_button_down() -> void:
	if PlayerCursor.held_item != null:
		return
	if PantryInventory.inventory.get(item_resource.id, 0) > 0:
		PantryInventory.remove_item(item_resource.id, 1)
		var new_item = item_scene.instantiate()
		new_item.food_data = item_resource
		
		# adding item to world
		var world_parent: Node = null
		if WORLD_NODE_PATH != NodePath(""):
			if get_tree().current_scene.has_node(WORLD_NODE_PATH):
				world_parent = get_tree().current_scene.get_node(WORLD_NODE_PATH)
			else:
				push_error("WORLD_NODE_PATH does not exist; adding to current_scene root instead.")
		if world_parent == null:
			world_parent = get_tree().current_scene

		world_parent.add_child(new_item)

		new_item.global_position = new_item.get_global_mouse_position()

		if new_item.has_method("_on_click_area_input_event"):
			new_item._on_click_area_input_event(null, null, 0)
		else:
			if new_item.has_variable("selected"):
				new_item.selected = true
			if new_item.has_variable("freeze"):
				new_item.freeze = true
	else:
		print("item not in inventory")

func _process(_delta: float) -> void:
	if Input.is_action_just_released("Lclick"):
		if can_drop and PlayerCursor.held_item != null:
			print("item dropped")
			emit_signal("item_dropped", PlayerCursor.held_item)
			PantryInventory.add_item(PlayerCursor.held_item.food_data.id, 1)
			PlayerCursor.held_item.queue_free()

func _on_mouse_entered() -> void:
	can_drop = true

func _on_mouse_exited() -> void:
	can_drop = false
