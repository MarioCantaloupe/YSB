extends Button

#signal item_dropped(item)

@export var item_resource: ItemData
@export var infinite_resources: bool = false

var item_scene := preload("res://02_scenes/02_objects/item/item.tscn")
var can_drop := false

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

	if infinite_resources:
		var infinite_state = ItemState.new()
		infinite_state.data = item_resource
		spawn_new_item(infinite_state)
		return

	if PantryInventory.has_item(item_resource.id):
		var state : ItemState = PantryInventory.pop_item_state(item_resource.id)
		spawn_new_item(state)
	else:
		print("Item not in inventory:", item_resource.id)


func spawn_new_item(state: ItemState) -> void:
	var new_item = item_scene.instantiate()
	get_tree().current_scene.get_node("WorldItems").add_child(new_item)

	new_item.global_position = get_global_mouse_position()

	if state != null:
		new_item.apply_item_state(state)
	else:
		new_item.food_data = item_resource

	PlayerCursor.held_item = new_item
	new_item.selected = true
	new_item.freeze = true


func _process(_delta: float) -> void:
	if Input.is_action_just_released("Lclick"):
		if can_drop and PlayerCursor.held_item != null:
			var state : ItemState = PlayerCursor.held_item.save_item_state()
			PantryInventory.add_item_state(state)
			PlayerCursor.held_item.queue_free()


func _on_mouse_entered() -> void:
	can_drop = true

func _on_mouse_exited() -> void:
	can_drop = false
