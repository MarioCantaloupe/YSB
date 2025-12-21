extends Node

@onready var generator: RandomItemGenerator = $item_spawner/random_item_generator

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_key"):
		randomize()
		print_random_item_state()

func _ready():
	randomize()  # resets rng
	print_random_item_state()


func print_random_item_state():
	# Generate a random state
	var state := generator.generate_random_item_state(generator.get_weights_dict())
	if state == null:
		print("Failed to generate ItemState")
		return

	# Determine ice level
	var ice_level_value := 0
	if state.is_frozen:
		ice_level_value = state.ice_level

	# pretyy print
	print("-------- Random ItemState --------")
	print("Name: ", state.data.name)
	print("Type: ", state.data.type)
	print("Cookable: ", state.data.cookable, " | Cook Level: ", state.cook_level)
	print("Cuttable: ", state.data.cuttable, " | Chop Level: ", state.chop_level)
	print("Cleanable: ", state.data.cleanable, " | Is Clean: ", state.is_clean)
	print("Freezable: ", state.is_frozen)
	print("Ice Level: ", ice_level_value)
	print("Cooking Time: ", state.data.cooking_time)
	print("---------------------------------")
