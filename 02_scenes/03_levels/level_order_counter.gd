extends Node2D

@onready var string_curve: Path2D = $string_curve

var orders_given : int = 0

@export var note_scene : PackedScene
@export var note_scale : Vector2
# Define how many notes can fit on the string at once
@export var max_notes_on_string : int = 5

# Keep track of which slots are occupied (e.g., [false, true, false...])
var occupied_slots: Array[bool] = []

func _ready():
	# Initialize the slots as empty (false) when the game starts
	occupied_slots.resize(max_notes_on_string)
	occupied_slots.fill(false)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_key"):
		new_order()

func new_order():
	orders_given += 1
	spawn_note()

func spawn_note():
	# 1. Find all available slot indices
	var available_slots = []
	for i in range(max_notes_on_string):
		if not occupied_slots[i]:
			available_slots.append(i)
	
	# If the string is full, don't spawn (or handle it however you like)
	if available_slots.is_empty():
		print("String is full!")
		return

	# 2. Pick a random available slot
	var random_slot_index = available_slots.pick_random()
	
	# 3. Mark that slot as occupied
	occupied_slots[random_slot_index] = true

	# 4. Calculate the position based on the slot
	# We divide the string by (slots + 1) so we don't spawn exactly on the edge (0.0 or 1.0)
	var step = 1.0 / (max_notes_on_string + 1)
	var progress_ratio = step * (random_slot_index + 1)

	# 5. Spawn the note
	var path_follow = PathFollow2D.new()
	string_curve.add_child(path_follow)
	path_follow.progress_ratio = progress_ratio
	
	var note = note_scene.instantiate()
	note.scale = note_scale
	path_follow.add_child(note)
	note.order_number_label.text = "Nº0" + str(orders_given)
	note.order_number = orders_given
	
	note.note_was_taken.connect(_on_note_taken.bind(note, random_slot_index))



# This function runs when the signal is received
func _on_note_taken(note_node: Node, slot_index: int):
	print("Manager received signal. Note ", note_node.order_number, " is leaving.")
	
	# 1. Wait for the note's animation to finish
	# We access the note's animation player
	await note_node.animation_player.animation_finished
	
	# 2. Logic for the GameSystem (Your TODO)
	print("Order added to GameSystem logic goes here.")
	#note_node.order_gen
	
	# 3. Free the slot (The most important part for your original problem)
	occupied_slots[slot_index] = false
	
	# 4. Destroy the note from memory
	note_node.queue_free()
