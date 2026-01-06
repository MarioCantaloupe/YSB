extends Node2D
class_name OrderNote


signal note_was_taken(order_id : int)

@onready var pinza: Sprite2D = $pinza
@onready var ticket_bg: NinePatchRect = $ticket_box/ticket_bg
@onready var ticket_rich_label: RichTextLabel = $ticket_box/VBoxContainer/MarginContainer_text/ticket_richLabel
@onready var order_number_label: Label = $ticket_box/VBoxContainer/MarginContainer_orderNum/order_number
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var order_data : OrderData
var taken : bool = false


func setup(order : OrderData) -> void:
	order_data = order
	order_number_label.text = "Nº" + str(order.order_id)

	var random_color := Color(randf_range(0.2, 0.9), randf_range(0.2, 0.9), randf_range(0.2, 0.9))
	pinza.self_modulate -= random_color

	ticket_rich_label.bbcode_enabled = true
	ticket_rich_label.text = OrderPrinter.build_text(order_data)

	animation_player.play("note_appear")



func note_taken() -> void:
	if taken:
		return

	taken = true
	animation_player.play_backwards("note_appear")
	emit_signal("note_was_taken", order_data.order_id)


func _on_ticket_box_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("Lclick"):
		note_taken()


func _on_ticket_box_mouse_entered() -> void:
	PlayerCursor.set_cursor(PlayerCursor.CursorType.CAN_INTERACT)


func _on_ticket_box_mouse_exited() -> void:
	PlayerCursor.set_cursor(PlayerCursor.CursorType.POINT)
