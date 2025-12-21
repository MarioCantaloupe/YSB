extends Node

var inventory: Dictionary = {}


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
