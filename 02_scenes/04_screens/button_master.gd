extends Button
class_name DynamicButton

@export var hover_scale : Vector2 = Vector2(1.1, 1.1)
@export var pressed_scale : Vector2 = Vector2(0.9, 0.9)
@export var hover_rotation: float = 0

func _ready() -> void:
	mouse_entered.connect(_button_enter)
	mouse_exited.connect(_button_exit)
	pressed.connect(_button_pressed)

	call_deferred("_init_pivot")

func _init_pivot() -> void:
	pivot_offset = size/2.0

func _button_enter() -> void:
	var button_hover_tween : Tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	button_hover_tween.tween_property(self, "scale", hover_scale, 0.1)
	button_hover_tween.tween_property(self, "rotation_degrees", hover_rotation, 0.1)
	
	if not PlayerCursor.is_knife:
		PlayerCursor.set_cursor(PlayerCursor.CursorType.CAN_INTERACT)

func _button_exit() -> void:
	var button_exit_tween : Tween = create_tween().set_parallel(true)
	button_exit_tween.tween_property(self, "scale", Vector2.ONE, 0.1).set_trans(Tween.TRANS_SINE)
	button_exit_tween.tween_property(self, "rotation_degrees", 0 , 0.1).set_trans(Tween.TRANS_SINE)
	
	if not PlayerCursor.is_knife:
		PlayerCursor.set_cursor(PlayerCursor.CursorType.POINT)

func _button_pressed() -> void:
	var button_press_tween : Tween = create_tween()
	button_press_tween.tween_property(self, "scale", pressed_scale, 0.06).set_trans(Tween.TRANS_SINE)
	button_press_tween.tween_property(self, "scale", hover_scale, 0.12).set_trans(Tween.TRANS_SINE)
