extends Sprite2D

var shadow_offset : float = 20
var floating_shadow_offset : float = 30
var pickup_lerp_speed: float = 5


@onready var item = get_parent()
var item_floating: bool

func _physics_process(delta: float) -> void:
	var target_y: float
	
	# 1. Grabbed by cursor
	if item_floating:
		target_y = shadow_offset + floating_shadow_offset

	# 2. Resting on station
	elif item.has_reached_rest:
		target_y = shadow_offset

	# 3. Resting on floor
	elif item.distance_to_fake_floor < 1:
		target_y = shadow_offset

	# 4. Flying through air
	else:
		target_y = item.distance_to_fake_floor
	
	
	if item.distance_to_fake_floor < 1:
		position.y = lerp(position.y, target_y, delta * pickup_lerp_speed)
	else:
		position.y = lerp(position.y, target_y, delta * pickup_lerp_speed*4)
		
	#TODO: fix shadow offset when item is put on station. this happens because when releasing item, shadow moves but item doesnt fall


func _on_item_item_grabbed(floating) -> void:
	if floating:
		item_floating = true
	else:
		item_floating = false
	
