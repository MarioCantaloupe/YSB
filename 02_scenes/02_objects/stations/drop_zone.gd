extends Node2D
class_name DropZone
signal zone_selected(bool, Item)
var is_occupied : bool = false
var held_item = null


@onready var click_area: Area2D = $click_area
@onready var debug_visuals: CollisionShape2D = $click_area/CollisionShape2D

#func _ready() -> void:
	#click_area.input_event.connect(_click_area_input_event)

func _ready() -> void:
	match is_occupied:
		true:
			debug_visuals.debug_color = Color("fe00316b")
		false:
			debug_visuals.debug_color = Color("0099b36b")

func select(new_held_item):
	if held_item != null and held_item != new_held_item:
		held_item.clear_from_station()
		# fully release our reference
		held_item = null
		is_occupied = false

	held_item = new_held_item
	is_occupied = true
	emit_signal("zone_selected", true, new_held_item)
	debug_visuals.debug_color = Color("fe00316b")

func deselect():
	is_occupied = false
	emit_signal("zone_selected", false, null)
	if held_item != null:
		held_item.clear_from_station()
		held_item = null
	
	debug_visuals.debug_color = Color("0099b36b")

func get_held_item() -> Item:
	if not is_occupied:
		print_debug("Station" + str(self) + "is free")
		return
	
	return held_item
	
#func _click_area_input_event(_viewport: Node, event: InputEvent, _shapeidx : int):
	#if event.is_action_released("Lclick"):
		#select(PlayerCursor.held_item)
