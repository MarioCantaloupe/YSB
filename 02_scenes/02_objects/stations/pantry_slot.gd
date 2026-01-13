extends Control
class_name PantrySlot

signal out_of_ingredients(item : ItemData)

@export var item_resource: ItemData
@export var infinite_resources := false

@onready var image: TextureRect = $PanelContainer/VBoxContainer/Image
@onready var label: Label = $PanelContainer/VBoxContainer/Label
@onready var drop_area: Area2D = $drop_area
@onready var collision: CollisionShape2D = $drop_area/collision

var item_scene := preload("res://02_scenes/02_objects/item/item.tscn")
var can_drop := false



func _ready():
	# Button = visuals only
	image.texture = item_resource.sprite_grid[0][0]
	label.text = item_resource.name

	# Area2D signals
	drop_area.mouse_entered.connect(_on_area_entered)
	drop_area.mouse_exited.connect(_on_area_exited)
	drop_area.input_event.connect(_on_area_input)

	# Keep Area2D size synced to UI
	resized.connect(_update_collision)
	_update_collision()

	
func _update_collision():
	var shape := RectangleShape2D.new()
	shape.size = size
	collision.shape = shape
	drop_area.position = size * 0.5

func _on_area_input(_viewport, event: InputEvent, _shape_idx):
	
	if PlayerCursor.is_knife:
		return
	
	if event.is_action_released("Lclick") and PlayerCursor.held_item:
		accept_item(PlayerCursor.held_item)
		return

	if event.is_action_pressed("Lclick"):
		var state: ItemState = null
		if infinite_resources:
			state = ItemState.new()
			state.data = item_resource
		elif PantryInventory.has_item(item_resource.id):
			state = PantryInventory.pop_item_state(item_resource.id)
		else:
			PlayerCursor.show_tip("Sin ingrediente")
			emit_signal("out_of_ingredients", item_resource)
			return
		_spawn_item(state)


func _spawn_item(state: ItemState):
	var new_item = item_scene.instantiate()
	if get_tree().current_scene.get_node("WorldItems"):
		get_tree().current_scene.get_node("WorldItems").add_child(new_item)
	else:
		get_tree().current_scene.add_child(new_item)
	new_item.global_position = get_global_mouse_position()
	new_item.apply_item_state(state)

	PlayerCursor.held_item = new_item
	new_item.selected = true
	new_item.freeze = true

func _on_area_entered():
	can_drop = true
	#PlayerCursor.set_cursor(PlayerCursor.CursorType.CAN_INTERACT)

func _on_area_exited():
	can_drop = false
	#PlayerCursor.set_cursor(PlayerCursor.CursorType.POINT)


func accept_item(item):
	if not item:
		push_error("NULL dropped")
		return
	var state = item.save_item_state()
	PantryInventory.add_item_state(state)
	item.queue_free()
