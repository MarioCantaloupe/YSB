extends Node2D

var is_knife_picked_up : bool = false
@onready var sprite: Sprite2D = $sprite

func _on_click_area_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if Input.is_action_just_pressed("Lclick"):
		if not is_knife_picked_up:
			is_knife_picked_up = true
			PlayerCursor.toggle_knife()
			sprite.modulate.a = 0.2
		
		else:
			is_knife_picked_up = false
			sprite.modulate.a = 1
			PlayerCursor.toggle_knife()
