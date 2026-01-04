extends Node2D

@export var blender_audio : AudioStream
@export var held_items : Array = []
@onready var drop_zone: Area2D = $drop_zone
@onready var button: Button = $Button
@onready var blender_fluid: Sprite2D = $blender_fluid

var can_drop : bool
var blended_color : Color

func _ready() -> void:
	pass

func _on_button_pressed() -> void:
	blend()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("Lclick"):
		var input_item = PlayerCursor.held_item
		print("dropped item: " + str(PlayerCursor.held_item))
		if PlayerCursor.held_item and can_drop:
			held_items.append(input_item.food_data.average_color)
			blended_color = get_array_average_color()
			PlayerCursor.held_item.queue_free()

func get_array_average_color() -> Color:
	var sum_r := 0.0
	var sum_g := 0.0
	var sum_b := 0.0

	if held_items.is_empty():
		return Color.WHITE  #cum

	for item in held_items:
		var c: Color = item
		sum_r += c.r
		sum_g += c.g
		sum_b += c.b

	var count := float(held_items.size())
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

func _on_drop_zone_mouse_entered() -> void:
	can_drop = true
	print(can_drop)
func _on_drop_zone_mouse_exited() -> void:
	can_drop = false
	print(can_drop)
