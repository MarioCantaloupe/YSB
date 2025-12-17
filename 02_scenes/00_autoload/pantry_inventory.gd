extends Node

# inventory[id: String] = amount: int
var inventory: Dictionary = {}

func add_item(id: String, amount: int = 1):
	inventory[id] = inventory.get(id, 0) + amount

func remove_item(id: String, amount: int = 1) -> bool:
	if inventory.get(id, 0) < amount:
		return false
	inventory[id] -= amount
	if inventory[id] <= 0:
		inventory.erase(id)
	return true

func has_item(id: String, amount: int = 1) -> bool:
	return inventory.get(id, 0) >= amount
