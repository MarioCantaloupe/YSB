extends Sprite2D

var shadow_offset : float = 20
var floating_shadow_offset : float = 30
var pickup_lerp_speed: float = 5


@onready var item = get_parent()
var item_floating: bool

func _physics_process(delta: float) -> void:
	var target_y: float
	
	# states: flung, resting on floor, resting on station, held
	# flung = item_floating
	# resting on floor = not item_selected and not item.has_reached rest
	# resting on station = item.has_reached_rest
	# held = item.selected
	
	if item_floating:
		target_y = shadow_offset + floating_shadow_offset
	else:
		target_y = shadow_offset
	
	if item.has_reached_rest and not item.selected:
		target_y = shadow_offset
	
	if not item.selected and item.distance_to_fake_floor > 1:
		target_y = item.distance_to_fake_floor
	
	if item.distance_to_fake_floor < 1:
		position.y = lerp(position.y, target_y, delta * pickup_lerp_speed)
	else:
		position.y = lerp(position.y, target_y, delta * pickup_lerp_speed*4)
		
	#TODO: fix shadow offset when item is put on station
	print(target_y)


func _on_item_item_grabbed(floating) -> void:
	if floating:
		item_floating = true
	else:
		item_floating = false
	
