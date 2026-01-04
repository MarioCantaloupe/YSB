extends Button
class_name DynamicButton

@export_group("Dynamic animation")
@export var hover_scale : Vector2 = Vector2(1.1, 1.1)
@export var pressed_scale : Vector2 = Vector2(0.9, 0.9)
@export var hover_rotation: float = 0

@export_group("Audio")
@export var hover_audio : AudioStream = preload("res://01_assets/03_sound/menu/click_003.ogg")
@export var hover_audio_volume : float
@export var click_audio : AudioStream = preload("res://01_assets/03_sound/menu/select_004.ogg")
@export var click_audio_volume : float
@export var audio_variation : float

func _ready() -> void:
	mouse_entered.connect(_button_enter)
	mouse_exited.connect(_button_exit)
	pressed.connect(_button_pressed)
	
	
	call_deferred("_init_pivot")

func _init_pivot() -> void:
	pivot_offset = size/2.0

func _button_enter() -> void:
	if PlayerCursor.is_knife or PlayerCursor.is_holding:
		return
	
	var button_hover_tween : Tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	button_hover_tween.tween_property(self, "scale", hover_scale, 0.1)
	button_hover_tween.tween_property(self, "rotation_degrees", hover_rotation, 0.1)
	
	if hover_audio:
		AudioManager.play_oneshot(hover_audio,
		click_audio_volume,
		1 + randf_range(-audio_variation, audio_variation),
		0, AudioManager.Bus.UI)
	
	if not PlayerCursor.is_knife:
		PlayerCursor.set_cursor(PlayerCursor.CursorType.CAN_INTERACT)

func _button_exit() -> void:
	if PlayerCursor.is_knife or PlayerCursor.is_holding:
		return
	
	var button_exit_tween : Tween = create_tween().set_parallel(true)
	button_exit_tween.tween_property(self, "scale", Vector2.ONE, 0.1).set_trans(Tween.TRANS_SINE)
	button_exit_tween.tween_property(self, "rotation_degrees", 0 , 0.1).set_trans(Tween.TRANS_SINE)
	
	if not PlayerCursor.is_knife:
		PlayerCursor.set_cursor(PlayerCursor.CursorType.POINT)

func _button_pressed() -> void:
	if PlayerCursor.is_knife or PlayerCursor.is_holding:
		return
	
	var button_press_tween : Tween = create_tween()
	button_press_tween.tween_property(self, "scale", pressed_scale, 0.06).set_trans(Tween.TRANS_SINE)
	button_press_tween.tween_property(self, "scale", hover_scale, 0.12).set_trans(Tween.TRANS_SINE)
	
	if click_audio:
		AudioManager.play_oneshot(click_audio,
		click_audio_volume,
		1 + randf_range(-audio_variation, audio_variation),
		0, AudioManager.Bus.UI)
