extends Node2D

signal note_was_taken

@onready var order_gen: Node = $orderGenerator_logic
@onready var pinza: Sprite2D = $pinza
@onready var ticket_bg: NinePatchRect = $ticket_box/ticket_bg
@onready var ticket_label: Label = $ticket_box/VBoxContainer/MarginContainer_text/ticket_label
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
	var random_value = randf_range(0.8, 1)
	ticket_bg.self_modulate = Color(random_value,random_value,random_value)
	
	animation_player.play("note_appear")
	

func update_ticket():
	
	var lines: Array[String] = []

	lines.append("Bocata")
		
	for item_state: ItemState in order_gen.bocata_ingredients:
		if item_state == null or item_state.data == null:
			continue

		lines.append(item_state.data.name) # name
		lines.append("Chop: %d Cook: %d" % [item_state.chop_level, item_state.cook_level]) #chop + cook
		lines.append("---")  # separator
	
	 #TODO the drinks should be unlocked after a while
	lines.append("Bebida")
	for item_state: ItemState in order_gen.drink_ingredients:
		if item_state == null or item_state.data == null:
			continue

		lines.append(item_state.data.name) # name
		lines.append("Cook: " + str(item_state.cook_level)) #chop + cook
		lines.append("---")  # separator
	
	ticket_label.text = "\n".join(lines)

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
