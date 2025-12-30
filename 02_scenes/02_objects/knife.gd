extends Node2D

var is_knife_picked_up : bool = false
@onready var sprite: Sprite2D = $sprite
@onready var audio_player: AudioStreamPlayer2D = $audio_player


func _on_click_area_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if Input.is_action_just_pressed("Lclick"):
		if not is_knife_picked_up:
			is_knife_picked_up = true
			PlayerCursor.toggle_knife()
			var tween : Tween = create_tween()
			tween.tween_property(sprite, "modulate", Color(1.0, 1.0, 1.0, 0.2), .2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
			audio_player.play()
		
		else:
			is_knife_picked_up = false
			var tween : Tween = create_tween()
			tween.tween_property(sprite, "modulate", Color(1.0, 1.0, 1.0, 1.0), .2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
			PlayerCursor.toggle_knife()


func _on_click_area_mouse_entered() -> void:
	if not PlayerCursor.is_knife:
		PlayerCursor.set_cursor(PlayerCursor.CursorType.CAN_INTERACT)


func _on_click_area_mouse_exited() -> void:
	if not PlayerCursor.is_knife:
		PlayerCursor.set_cursor(PlayerCursor.CursorType.POINT)
