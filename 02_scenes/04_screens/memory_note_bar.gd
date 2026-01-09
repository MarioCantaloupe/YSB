extends Control
class_name MemoryNotesBar

@export var max_active_notes := 5
@export var memory_note_scene: PackedScene
@export var selectable_notes : bool = false

@onready var hbox := $HBoxContainer

func _ready():
	# Initialize all active orders that exist in GameSystem
	for order in GameSystem.active_orders:
		add_order(order)

	# Listen for new accepted orders
	GameSystem.order_accepted.connect(add_order)
	GameSystem.order_completed.connect(remove_order)

func add_order(order_data: OrderData):
	if hbox.get_child_count() >= max_active_notes:
		print("Too many active orders!") #TODO show ingame
		return

	var note: MemoryNote = memory_note_scene.instantiate()
	hbox.add_child(note)
	if selectable_notes:
		note.is_selectable = true
		note.order_selected.connect(_on_order_selected)
	note.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	note.setup(order_data)

func remove_order(order_id: int):
	for child in hbox.get_children():
		if child.order_data.order_id == order_id:
			child.queue_free()
			return
			
func _on_order_selected(order_id : int):
	if not selectable_notes:
		return
	
	
