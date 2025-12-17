extends Sprite2D

var shadow_offset : float = 20
var floating_shadow_offset : float = 30
var pickup_lerp_speed: float = 5
@export var shadow_scale = Vector2(0.5,0.2)

@onready var item = get_parent()
var item_floating: bool

func _physics_process(delta: float) -> void:
	var target_y: float
	
	# grabbed
	if item_floating:
		target_y = shadow_offset + floating_shadow_offset
		scale = Vector2(0.35,0.15)
	# resting station
	elif item.has_reached_rest:
		target_y = shadow_offset
		scale = shadow_scale
	# resting floor
	elif item.distance_to_fake_floor < 1:
		target_y = shadow_offset
		scale = shadow_scale
	# flung
	else:
		target_y = item.distance_to_fake_floor
		#scaling shadow
		scale.x = clampf((remap(item.distance_to_fake_floor, 500, 0, 0.05, 0.5)), 0.05, 0.5)
		scale.y = clampf((remap(item.distance_to_fake_floor, 500, 0, 0.02, 0.2)), 0.02, 0.2)
		self_modulate.a = clampf(remap(item.distance_to_fake_floor, 500, 0, 0.1, 0.4), 0, 1)
	
	if item.distance_to_fake_floor < 1:
		position.y = lerp(position.y, target_y, delta * pickup_lerp_speed)
	else:
		position.y = lerp(position.y, target_y, delta * pickup_lerp_speed*4)
		


func _on_item_item_grabbed(floating) -> void:
	if floating:
		item_floating = true
	else:
		item_floating = false
	
