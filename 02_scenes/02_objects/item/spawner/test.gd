extends Node2D

@onready var item: Item = $item
@onready var state_gen: RandomItemStateGenerator = $item/RandomItemStateGenerator

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var state = state_gen.generate_item_state()
	item.apply_item_state(state)
	state_gen.pretty_print_item_state(state)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_key"):
		var state = state_gen.generate_item_state()
		item.apply_item_state(state)
		state_gen.pretty_print_item_state(state)
