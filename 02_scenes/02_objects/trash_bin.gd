extends Node2D

@onready var controller: Node2D = $controller
var tween : Tween
@onready var eat_anim: AnimatedSprite2D = $controller/eat_anim

func _on_drop_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_released("Lclick") and PlayerCursor.held_item != null:
		print("item_dropped")
		PlayerCursor.held_item.queue_free()
		
		if tween:
			if tween.is_running():
				print("not playing tween")
				return
		
		eat_anim.show()
		eat_anim.play("eat")
		tween = create_tween()
		controller.scale = Vector2(0.6, 0.6)
		tween.tween_property(controller,
		"scale",
		Vector2.ONE,
		1
		).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
