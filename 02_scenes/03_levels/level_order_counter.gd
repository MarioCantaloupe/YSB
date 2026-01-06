extends LevelScene

@onready var string_curve: Path2D = $string_curve
@onready var tip_box: GameTipPanel = %TipBox

@export var note_scene : PackedScene
@export var note_scale : Vector2
var max_notes_on_string : int


func _ready() -> void:
	GameSystem.start_game()
	tip_box.tip_box_clicked.connect(tip_shown)
	max_notes_on_string = GameSystem.max_notes_on_string
	
	# creating pending order notes
	for i in range(max_notes_on_string):
		var order_id := GameSystem.occupied_slots[i]
		if order_id == -1:
			continue

		var order := GameSystem.get_pending_order(order_id)
		if order:
			_restore_note(order, i)

	
	if not GameSystem.orders_tip_shown:
		await get_tree().create_timer(3).timeout
		tip_box.show_tip()


func tip_shown() -> void:
	GameSystem.orders_tip_shown = true


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_key"):
		spawn_note()


func spawn_note() -> void:
	var available_slots : Array[int] = []

	for i in range(max_notes_on_string):
		if GameSystem.occupied_slots[i] == -1:
			available_slots.append(i)

	if available_slots.is_empty():
		print("String is full!")
		return

	var slot_index : int = available_slots.pick_random()

	var step : float = 1.0 / (max_notes_on_string + 1)
	var progress_ratio : float = step * (slot_index + 1)

	var path_follow := PathFollow2D.new()
	string_curve.add_child(path_follow)
	path_follow.progress_ratio = progress_ratio

	var order := GameSystem.create_order()

	var note : OrderNote = note_scene.instantiate()
	note.scale = note_scale
	path_follow.add_child(note)
	note.setup(order)
	GameSystem.occupied_slots[slot_index] = order.order_id
	note.note_was_taken.connect(_on_note_taken.bind(note, slot_index))


func _on_note_taken(order_id : int, note_node : Node, slot_index : int) -> void:
	GameSystem.accept_order(order_id)
	GameSystem.occupied_slots[slot_index] = -1
	note_node.queue_free()


func _restore_note(order : OrderData, slot_index : int) -> void:
	var step : float = 1.0 / (max_notes_on_string + 1)
	var progress_ratio : float = step * (slot_index + 1)

	var path_follow := PathFollow2D.new()
	string_curve.add_child(path_follow)
	path_follow.progress_ratio = progress_ratio

	var note : OrderNote = note_scene.instantiate()
	note.scale = note_scale
	path_follow.add_child(note)
	note.setup(order)

	note.note_was_taken.connect(_on_note_taken.bind(note, slot_index))
