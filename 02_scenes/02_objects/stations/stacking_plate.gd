extends Node2D
class_name StackingPlate

@export var base_stack_offset := Vector2.ZERO
@export var drop_zone_scene: PackedScene

@onready var drop_zone : Node2D = $drop_zone
@onready var stack_slots := Node2D.new()  # igual que ingredient_stack, de abajo a arriba

var ingredient_stack: Array[Item] = [] #de abajo a arriba
var drop_zones: Array[Node2D] = []
var current_height := 0.0

func _ready() -> void:
	add_child(stack_slots)
	drop_zones.append(drop_zone)
	drop_zone.zone_selected.connect(_on_zone_selected)
	_position_top_drop_zone()


func _on_zone_selected(state: bool, item: Item) -> void:
	if state and item:
		add_item(item)
	else:
		if ingredient_stack.size() > 0: #doble seguridad porsiacá
			remove_top_item()


func add_item(item: Item) -> void:
	ingredient_stack.append(item)

	item.freeze = true
	item.gravity_scale = 0
	item.rest_point = _item_position(item)

	current_height += item.ingredient_height * 0.25
	for ingredient in ingredient_stack:
		print_debug("ingredient in stack: " + str(ingredient.food_data.name))

	_spawn_next_drop_zone()
	_update_interactions()


func remove_top_item() -> void:
	if ingredient_stack.is_empty():
		return

	var item : Item = ingredient_stack.pop_back()

	current_height -= item.ingredient_height * 0.25

	item.freeze = false
	item.gravity_scale = 1
	item._set_has_reached_rest(false)

	_remove_top_drop_zone()
	_update_interactions()


func _spawn_next_drop_zone() -> void:
	if drop_zone_scene == null:
		return

	var dz := drop_zone_scene.instantiate()
	stack_slots.add_child(dz)
	drop_zones.append(dz)
	
	dz.zone_selected.connect(_on_zone_selected)
	_position_top_drop_zone()


func _remove_top_drop_zone() -> void:
	if drop_zones.size() <= 1:
		return #pa no crashear

	var dz : Node2D = drop_zones.pop_back() #takes from the top
	dz.queue_free()
	_position_top_drop_zone()

func _position_top_drop_zone() -> void:
	var dz : Node2D = drop_zones.back()
	dz.global_position = global_position + base_stack_offset + Vector2(0, -current_height)

func _item_position(item: Item) -> Vector2:
	var pos := global_position + base_stack_offset + Vector2(0, -current_height + item.ingredient_height * 0.5)
	return pos

func _update_interactions() -> void:
	var base_z := 10  # z of the bottom item

	for i in range(ingredient_stack.size()):
		var item := ingredient_stack[i]
		var is_top : bool = (i == ingredient_stack.size() - 1) # comprobar item de arriba
		var is_bottom : bool = (i == 0)
		item.click_area.input_pickable = is_top #ingredients intermedios no interactuables
		item.shadow.visible = is_bottom
		item.z_index = base_z + i #ordenación

func finish_bocata() -> Array[ItemState]:
	var finished_bocata : Array[ItemState] = []
	for ingredient in ingredient_stack:
		finished_bocata.append(ingredient.save_item_state())
	return finished_bocata
