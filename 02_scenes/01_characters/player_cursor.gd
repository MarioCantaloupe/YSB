extends Node2D

signal knife_mode_changed(is_knife: bool)

const VELOCITY_SAMPLES : int = 8

var velocity_buffer: Array[Vector2] = []
var previous_mouse_pos

var enabled = true

var is_knife = false
var is_holding = false
var held_item: RigidBody2D = null

enum CursorType {
	POINT,
	CAN_INTERACT,
	HOLDING,
	KNIFE,
}

var cursor_images := { #TODO placeholders
	CursorType.POINT: "res://01_assets/01_sprites/01_characters/cursor-png-1137.png",
	CursorType.CAN_INTERACT: "res://01_assets/01_sprites/01_characters/hand_point.png",
	CursorType.HOLDING: "res://01_assets/01_sprites/01_characters/cursor-png-1137.png",
	CursorType.KNIFE: "res://01_assets/01_sprites/01_characters/tinyKnife.png",
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_cursor(CursorType.POINT)
	Input.set_custom_mouse_cursor(load(cursor_images[1]), Input.CURSOR_POINTING_HAND)
	previous_mouse_pos = get_viewport().get_mouse_position()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()
	var mouse_pos = get_viewport().get_mouse_position()
	var velocity = (mouse_pos - previous_mouse_pos) / _delta
	previous_mouse_pos = mouse_pos
	
	velocity_buffer.append(velocity)
	if velocity_buffer.size() > VELOCITY_SAMPLES:
		velocity_buffer.pop_front()
	
func get_avg_mouse_velocity():
	if velocity_buffer.is_empty():
		return Vector2.ZERO
	var sum := Vector2.ZERO
	for v in velocity_buffer:
		sum += v
	return sum / velocity_buffer.size()
	
#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("debug_key"):
		#toggle_knife()
	
func toggle_knife():
	is_knife = !is_knife
	if is_knife:
		set_cursor(CursorType.KNIFE)
		emit_signal("knife_mode_changed", true)
	else:
		set_cursor(CursorType.POINT)
		emit_signal("knife_mode_changed", false)
	
	print("is_knife set to " + str(is_knife))
	
func set_cursor(cursor_type: CursorType):
	if cursor_images.has(cursor_type):
		Input.set_custom_mouse_cursor(load(cursor_images[cursor_type]))
		print("cursor changed to: " + str(cursor_type))

func enable_cursor(boolean : bool):
	if boolean:
		PlayerCursor.enabled = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		PlayerCursor.enabled = false
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
