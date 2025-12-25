extends Node2D


func _on_drop_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_released("Lclick"):
		print("item_dropped")
		PlayerCursor.held_item.queue_free()
