extends Node2D
signal zone_selected
var is_occupied : bool
var held_item = null

func _draw():
	draw_circle(Vector2(0,0), 75, Color.BLANCHED_ALMOND) #TODO delete debug visuals
	
func select(new_held_item):
	if held_item != null and held_item != new_held_item:
		deselect()
	held_item = new_held_item
	modulate = Color.WEB_MAROON #TODO delete debug visuals
	is_occupied = true
	emit_signal("zone_selected")

func deselect():
	modulate = Color.WHITE #TODO delete debug visuals
	is_occupied = false
	held_item.clear_from_station()
