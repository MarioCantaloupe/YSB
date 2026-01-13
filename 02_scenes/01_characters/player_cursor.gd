extends Node2D

signal knife_mode_changed(is_knife: bool)

const VELOCITY_SAMPLES : int = 8

const CURSOR_REFERENCE_RESOLUTION := Vector2i(1280, 720)

@onready var tip: RichTextLabel = $Tip

var cursor_scale := 1.0
var scaled_cursor_cache := {}

var velocity_buffer: Array[Vector2] = []
var previous_mouse_pos

var enabled := true
var is_knife := false
var is_holding := false : set = _set_is_holding
var held_item: RigidBody2D = null

enum CursorType {
	POINT,
	CAN_INTERACT,
	CAN_HOLD,
	HOLDING,
	KNIFE,
}

# Cursor definitions (texture + hotspot in one place)
var cursor_data := {
	CursorType.POINT: {
		"texture": preload("res://01_assets/01_sprites/01_characters/cursor/cursor_point.png"),
		"hotspot": Vector2(17, 15),
	},
	CursorType.CAN_INTERACT: {
		"texture": preload("res://01_assets/01_sprites/01_characters/cursor/cursor_canInteract.png"),
		"hotspot": Vector2(38, 23),
	},
	CursorType.CAN_HOLD: {
		"texture": preload("res://01_assets/01_sprites/01_characters/cursor/cursor_canHold.png"),
		"hotspot": Vector2(47, 67),
	},
	CursorType.HOLDING: {
		"texture": preload("res://01_assets/01_sprites/01_characters/cursor/cursor_holding.png"),
		"hotspot": Vector2(47, 67),
	},
	CursorType.KNIFE: {
		"texture": preload("res://01_assets/01_sprites/01_characters/cursor/cursor_knife.png"),
		"hotspot": Vector2(0, 0),
	},
}

func _ready() -> void:
	update_cursor_scale()
	scaled_cursor_cache.clear()
	set_cursor(CursorType.POINT)
	previous_mouse_pos = get_viewport().get_mouse_position()

func _process(delta: float) -> void:
	global_position = get_global_mouse_position()

	var mouse_pos := get_viewport().get_mouse_position()
	var velocity : Vector2 = (mouse_pos - previous_mouse_pos) / delta
	previous_mouse_pos = mouse_pos

	velocity_buffer.append(velocity)
	if velocity_buffer.size() > VELOCITY_SAMPLES:
		velocity_buffer.pop_front()

func get_avg_mouse_velocity() -> Vector2:
	if velocity_buffer.is_empty():
		return Vector2.ZERO

	var sum := Vector2.ZERO
	for v in velocity_buffer:
		sum += v

	return sum / velocity_buffer.size()

func toggle_knife() -> void:
	is_knife = !is_knife

	if is_knife:
		set_cursor(CursorType.KNIFE)
		emit_signal("knife_mode_changed", true)
	else:
		set_cursor(CursorType.POINT)
		emit_signal("knife_mode_changed", false)

func set_cursor(cursor_type: CursorType) -> void:
	if not cursor_data.has(cursor_type):
		push_warning("Cursor type not found: %s" % cursor_type)
		return

	var scaled := get_scaled_cursor(cursor_type)

	Input.set_custom_mouse_cursor(
		scaled.texture,
		Input.CURSOR_ARROW,
		scaled.hotspot
	)


func enable_cursor(value: bool) -> void:
	enabled = value
	Input.set_mouse_mode(
		Input.MOUSE_MODE_VISIBLE if value else Input.MOUSE_MODE_HIDDEN
	)

func _set_is_holding(value: bool) -> void:
	is_holding = value

func update_cursor_scale() -> void:
	var viewport_size := get_viewport().get_visible_rect().size
	cursor_scale = min(
		viewport_size.x / CURSOR_REFERENCE_RESOLUTION.x,
		viewport_size.y / CURSOR_REFERENCE_RESOLUTION.y
	)
	cursor_scale = clamp(cursor_scale, 0.5, 2.0)

func get_scaled_cursor(cursor_type: CursorType) -> Dictionary:
	if scaled_cursor_cache.has(cursor_type):
		return scaled_cursor_cache[cursor_type]

	var data = cursor_data[cursor_type]
	var original_tex: Texture2D = data.texture
	var original_hotspot: Vector2 = data.hotspot

	var image := original_tex.get_image()
	var new_size := Vector2i(image.get_size() * cursor_scale)

	image.resize(new_size.x, new_size.y, Image.INTERPOLATE_LANCZOS)

	var scaled_texture := ImageTexture.create_from_image(image)
	var scaled_hotspot := original_hotspot * cursor_scale

	var result := {
		"texture": scaled_texture,
		"hotspot": scaled_hotspot
	}

	scaled_cursor_cache[cursor_type] = result
	return result


func show_tip(tipText : String):
	tip.text = tipText
	tip.show()
	await get_tree().create_timer(1).timeout
	tip.hide()
