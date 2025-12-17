extends Control

var can_drop
var inventory : Dictionary = {}

func _ready() -> void:
	subscribe_to_buttons()

func _add_to_inventory(item : Resource, amount: int):
	var id : String = item.id
	inventory[id] = inventory.get(id, 0) + amount

func remove_from_inventory(id: String, amount: int = 1) -> bool:
	PantryInventory.remove_item(id, amount)

	inventory[id] -= amount

	if inventory[id] <= 0:
		inventory.erase(id)

	return true


func subscribe_to_buttons():
	for button in $HBoxContainer.get_children():
		if button is Button:
			button.item_dropped.connect(self._on_item_dropped)
			print("connected to button" + str(button))

func _on_item_dropped(item):
	_add_to_inventory(item.food_data, 1)



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_key"):
		print(inventory)
