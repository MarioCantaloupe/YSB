extends Control

var can_drop
var inventory : Dictionary = {
	"item" : 0,
}

@onready var store_zone: Area2D = $store_zone


func _on_store_zone_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if Input.is_action_just_released("Lclick"):
		_add_to_inventory(PlayerCursor.held_item.food_data, 1)
		
func _add_to_inventory(item : Resource, amount: int):
	if inventory.has(item):
		inventory[item] += amount
	else:
		inventory[item] = 1
	print(inventory)

func _on_store_zone_mouse_entered() -> void:
	can_drop = true

func _on_store_zone_mouse_exited() -> void:
	can_drop = false
