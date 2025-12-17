extends Node2D
signal zone_selected(bool)
var is_occupied : bool = false
var held_item = null

#func _draw():
	#draw_circle(Vector2(0,0), 75, Color.BLANCHED_ALMOND) #TODO delete debug visuals
	
func select(new_held_item):
	# If another item was on this zone, clean it up fully
	if held_item != null and held_item != new_held_item:
		# tell the previous item it's no longer on this station
		held_item.clear_from_station()
		# fully release our reference
		held_item = null
		is_occupied = false

	held_item = new_held_item
	#modulate = Color.WEB_MAROON #TODO delete debug visuals
	is_occupied = true
	emit_signal("zone_selected", true)

func deselect():
	modulate = Color.WHITE #TODO delete debug visuals
	is_occupied = false
	emit_signal("zone_selected", false)
	if held_item != null:
		held_item.clear_from_station()
		held_item = null
