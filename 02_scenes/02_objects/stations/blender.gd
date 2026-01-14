extends Node2D
class_name Blender

@export var blender_audio : AudioStream
@export var states_in_cup : Array[ItemState] = []
@onready var drop_zone: Area2D = $drop_zone
@onready var button: Button = $Button
@onready var blender_fluid: Sprite2D = $blender_fluid

var blended_color : Color

func _ready() -> void:
	blended_color = GameSystem.blender_fluid_color
	blender_fluid.self_modulate = blended_color
	states_in_cup = GameSystem.ingredient_states_in_blender
	GameSystem.order_completed.connect(empty_blender)
func _on_button_pressed() -> void:
	blend()

func _on_drop_zone_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if PlayerCursor.held_item == null:
		return
	
	if event.is_action_released("Lclick"):
		var input_state : ItemState = PlayerCursor.held_item.save_item_state()
		print("dropped item: ", input_state.data.name)
		states_in_cup.append(input_state)
		GameSystem.ingredient_states_in_blender.append(input_state)
		blended_color = get_array_average_color()
		GameSystem.blender_fluid_color = get_array_average_color()
		PlayerCursor.held_item.queue_free()

func get_array_average_color() -> Color:
	var sum_r := 0.0
	var sum_g := 0.0
	var sum_b := 0.0

	if states_in_cup.is_empty():
		return Color(0.888, 0.866, 0.79, 0.388)  #cum

	for state in states_in_cup:
		var c: Color = state.data.average_color
		sum_r += c.r
		sum_g += c.g
		sum_b += c.b

	var count := float(states_in_cup.size())
	return Color(
		sum_r / count,
		sum_g / count,
		sum_b / count,
		1
	)

func blend():
	var tween = create_tween()
	tween.tween_property(blender_fluid, "self_modulate", blended_color, 1)
	
	AudioManager.play_oneshot(blender_audio, 0, 1, 0, AudioManager.Bus.SFX)

func _on_button_mouse_entered() -> void:
	PlayerCursor.set_cursor(PlayerCursor.CursorType.CAN_INTERACT)

func _on_button_mouse_exited() -> void:
	PlayerCursor.set_cursor(PlayerCursor.CursorType.POINT)

func finish_drink() -> Array[ItemState]:
	return states_in_cup

func empty_blender(_order_id : int):
	states_in_cup.clear()
	blender_fluid.self_modulate = Color(0.0, 0.0, 0.0, 0.0)
