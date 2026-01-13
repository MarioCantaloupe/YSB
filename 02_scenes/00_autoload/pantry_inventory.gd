extends Node

@export_dir var item_data_folder : String = "res://02_scenes/02_objects/00_item_data/"

var inventory: Dictionary = {}

var open_tab : int = 0

@export var starting_items : Array[ItemData] = []

func _ready() -> void:
	load_starting_items()
	initialize_starting_inventory()

func add_item_state(state: ItemState) -> void:
	if state == null or state.data == null:
		push_error("Tried to add null ItemState to inventory")
		return

	var id := state.data.id

	if not inventory.has(id):
		inventory[id] = []

	inventory[id].append(state)
	print("Added item:", id, "Total:", inventory[id].size())


func pop_item_state(id: String) -> ItemState:
	if not inventory.has(id):
		return null

	if inventory[id].is_empty():
		return null

	var state: ItemState = inventory[id].pop_back()

	if inventory[id].is_empty():
		inventory.erase(id)

	return state


func has_item(id: String) -> bool:
	return inventory.has(id) and not inventory[id].is_empty()


func get_count(id: String) -> int:
	if not inventory.has(id):
		return 0
	return inventory[id].size()

func initialize_starting_inventory() -> void:
	for i in 2: #give 2 of every item
		for item_data in starting_items:
			var state := ItemState.new()
			state.data = item_data
			add_item_state(state)
		
func load_starting_items() -> void:
	starting_items.clear()

	var dir : DirAccess = DirAccess.open(item_data_folder)
	if dir == null:
		push_error("ItemData folder not found: %s" % item_data_folder)
		return

	dir.list_dir_begin()
	var file_name : String = dir.get_next()
	while file_name != "":
		if file_name.ends_with(".tres"):
			var res : Resource = load(item_data_folder + "/" + file_name)
			if res is ItemData:
				starting_items.append(res)
		file_name = dir.get_next()
	dir.list_dir_end()
	
func get_all_item_data() -> Array[ItemData]:
	return starting_items
	
func get_random_item_data() -> ItemData:
	if starting_items.is_empty():
		push_error("No ItemData available in inventory pool")
		return null
	return starting_items.pick_random()
