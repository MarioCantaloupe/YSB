extends Node2D

signal note_was_taken

@onready var order_gen: Node = $orderGenerator_logic
@onready var pinza: Sprite2D = $pinza
@onready var ticket_bg: NinePatchRect = $ticket_box/ticket_bg
@onready var ticket_label: Label = $ticket_box/VBoxContainer/MarginContainer_text/ticket_label
@onready var ticket_rich_label: RichTextLabel = $ticket_box/VBoxContainer/MarginContainer_text/ticket_richLabel
@onready var order_number_label: Label = $ticket_box/VBoxContainer/MarginContainer_orderNum/order_number
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var order_number : int = 00

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	order_gen.build_bocata()
	order_gen.build_drink()
	update_ticket()
	var random_color = Color(randf_range(.2,.9), randf_range(.2,.9), randf_range(.2,.9))
	pinza.self_modulate -= random_color
	
	animation_player.play("note_appear")
	

func update_ticket():
	var lines: Array[String] = []

	lines.append("[outline_size=5]Bocata[/outline_size]")

	for item_state: ItemState in order_gen.bocata_ingredients:
		if item_state == null or item_state.data == null:
			continue

		lines.append(format_item_line(item_state.data.name, item_state.cook_level, item_state.chop_level))

	lines.append("") # spacing

	lines.append("[outline_size=5]Bebida[/outline_size]")
	for item_state: ItemState in order_gen.drink_ingredients:
		if item_state == null or item_state.data == null:
			continue

		# Drinks only have cook level
		var cook := render_level("*", item_state.cook_level)
		lines.append("[left]%s[right]%s[/right][/left]" % [item_state.data.name, cook])

	ticket_rich_label.bbcode_enabled = true
	ticket_rich_label.text = "\n".join(lines)



func render_level(symbol: String, level: int, max_level: int = 3) -> String:
	var result := ""
	for i in max_level:
		if i < level:
			result += "[color=000000]%s[/color]" % symbol
		else:
			result += "[color=676767]%s[/color]" % symbol
	return result

func format_item_line(itemName: String, cook_level: int, chop_level: int) -> String:
	var cook := render_level("*", cook_level)
	var chop := render_level("/", chop_level)
	
	# [left] wraps the name, [right] wraps the levels
	return "[left]%s[right]%s %s[/right][/left]" % [itemName, cook, chop]


func note_taken():
	print("note number " + str(order_number) + "taken")
	animation_player.play_backwards("note_appear")
	print("added order to GameSystem")
	emit_signal("note_was_taken")

func _on_ticket_box_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("Lclick"):
		note_taken()


func _on_ticket_box_mouse_entered() -> void:
	PlayerCursor.set_cursor(PlayerCursor.CursorType.CAN_INTERACT)


func _on_ticket_box_mouse_exited() -> void:
	PlayerCursor.set_cursor(PlayerCursor.CursorType.POINT)
