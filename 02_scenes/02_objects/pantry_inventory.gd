extends Control

var can_drop
var inventory : Dictionary = {}

func _ready() -> void:
	subscribe_to_buttons()

func _add_to_inventory(item : Resource, amount: int):
	if inventory.has(item):
		inventory[item] += amount
	else:
		inventory[item] = 1
	print(item.name , inventory[item])

func subscribe_to_buttons():
	for button in $HBoxContainer.get_children():
		if button is Button:
			button.item_dropped.connect(self._on_item_dropped)
			print("connected to button" + str(button))

func _on_item_dropped(item):
	_add_to_inventory(item.food_data, 1)
