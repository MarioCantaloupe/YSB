extends Control
class_name MemoryNote

signal order_selected(order_id : int)

@onready var ticket_box: MarginContainer = $ticket_box
@onready var rich_label: RichTextLabel = $ticket_box/VBoxContainer/MarginContainer_text/ticket_richLabel
@onready var order_label: Label = $ticket_box/VBoxContainer/MarginContainer_orderNum/order_number
var tween : Tween = null

var order_data: OrderData
var hidden_y : float = -50
var shown_y : float = 0
var visible_strip_height: float = 20.0  # the part visible when collapsed
@export var is_selectable : bool = false

func setup(data: OrderData):
	order_data = data
	order_label.text = "#%02d" % data.order_id #padding con ceros antes de numero

	rich_label.bbcode_enabled = true
	rich_label.text = OrderPrinter.build_text(order_data)

	await get_tree().process_frame #esperar bulid_text

	# tamaño total
	var total_height := rich_label.get_minimum_size().y + order_label.get_minimum_size().y + 10.0
	rich_label.get_minimum_size().y = total_height

	hidden_y = -total_height + visible_strip_height
	shown_y = 0
	position.y = hidden_y


func _ready():
	ticket_box.mouse_entered.connect(_on_box_mouse_entered)
	ticket_box.mouse_exited.connect(_on_box_mouse_exited)
	position.y = hidden_y

func _on_box_mouse_entered():
	match is_selectable:
		false:
			if tween:
				tween.kill()
			tween = create_tween()
			tween.tween_property(self, "position:y", shown_y, 0.3
			).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		true:
			var tween_in : Tween = create_tween()
			tween_in.tween_property(self, "scale", Vector2.ONE, 0.2)


func _on_box_mouse_exited():
	match is_selectable:
		false:
			if tween:
				tween.kill()
			tween = create_tween()
			tween.tween_property(self, "position:y", hidden_y, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		true:
			var tween_out : Tween = create_tween()
			tween_out.tween_property(self, "scale", Vector2(1,1), 0.2)

func _gui_input(event: InputEvent) -> void:
	if not is_selectable:
		return
	
	if event.is_action_pressed("Lclick"):
		emit_signal("order_selected", order_data.order_id)
