extends Node
class_name RandomItemStateGenerator

# Folder containing all ItemData .tres files
# Godot docs: DirAccess
# https://docs.godotengine.org/en/stable/classes/class_diraccess.html
@export_dir var item_data_folder: String = "res://02_scenes/02_objects/00_item_data/"

# Weight configuration resource
# Designers create and assign this in the Inspector
@export var weight_config: IngredientWeightConfig

# Cooking
@export_group("State variables")
@export var min_cook_level: int = 0
@export var max_cook_level: int = 2
var max_allowed_cook_level : int = 2

# Chopping
@export var min_chop_level: int = 0
@export var max_chop_level: int = 2
var max_allowed_chop_level : int = 2

# Probabilities (0.0 – 1.0)
@export_range(0.0, 1.0) var frozen_chance: float = 0.15
@export_range(0.0, 1.0) var clean_chance: float = 0.8


# All loaded ItemData resources
var _item_data_by_type: Dictionary = {}

# Local RNG (do NOT use global randomize repeatedly)
# Godot docs:
# https://docs.godotengine.org/en/stable/classes/class_randomnumbergenerator.html
var _rng := RandomNumberGenerator.new()

func _init():
	_load_item_data()

func _ready() -> void:
	_rng.randomize()

	if weight_config == null:
		push_error("RandomItemStateGenerator: IngredientWeightConfig not assigned.")
		return

	_load_item_data()

func generate_item_state() -> ItemState:
	"""
	Returns a fully generated ItemState based on:
	- Loaded ItemData
	- IngredientWeightConfig
	- Editor-defined randomization settings
	"""

	var item_data := _get_random_item_data()
	if item_data == null:
		return null

	return _generate_item_state(item_data)


func _load_item_data() -> void:
	_item_data_by_type.clear()

	var dir := DirAccess.open(item_data_folder)
	if dir == null:
		push_error("ItemData folder not found: " + item_data_folder)
		return

	dir.list_dir_begin()
	var file_name := dir.get_next()

	while file_name != "":
		if file_name.ends_with(".tres"):
			var res := load(item_data_folder + "/" + file_name)
			if res is ItemData:
				if not _item_data_by_type.has(res.type):
					_item_data_by_type[res.type] = []
				_item_data_by_type[res.type].append(res)
		file_name = dir.get_next()

	dir.list_dir_end()

func _get_random_item_data() -> ItemData:
	var total_weight := 0

	for type in _item_data_by_type.keys():
		var weight := weight_config.get_weight(type)
		if weight <= 0:
			continue

		total_weight += weight * _item_data_by_type[type].size()

	if total_weight <= 0:
		push_error("RandomItemStateGenerator: total weight is zero.")
		return null

	var roll := _rng.randi_range(1, total_weight)
	var cumulative := 0

	for type in _item_data_by_type.keys():
		var weight := weight_config.get_weight(type)
		if weight <= 0:
			continue

		for item in _item_data_by_type[type]:
			cumulative += weight
			if roll <= cumulative:
				return item

	return null

func _generate_item_state(item_data: ItemData) -> ItemState:
	var state := ItemState.new()
	state.data = item_data

	# Cooking
	if item_data.cookable:
		var cook_value := _rng.randi_range(min_cook_level, max_cook_level)
		state.cook_level = clamp(
			cook_value,
			0,
			max_allowed_cook_level
		)

	# Chopping
	if item_data.cuttable:
		var chop_value := _rng.randi_range(min_chop_level, max_chop_level)
		state.chop_level = clamp(
			chop_value,
			0,
			max_allowed_chop_level
		)

	# Cleaning
	if item_data.cleanable:
		state.is_clean = _rng.randf() < clean_chance

	# Freezing (pure state, not ItemData capability)
	state.is_frozen = _rng.randf() < frozen_chance

	return state



func pretty_print_item_state(state: ItemState) -> void:
	"""
	Prints a human-readable representation of an ItemState to the console.
	Intended for debugging and designer verification.
	"""

	if state == null:
		print("ItemState: <null>")
		return

	if state.data == null:
		print("ItemState has no ItemData assigned.")
		return

	print("---------------------------------")
	print("ItemState Debug Output")
	print("---------------------------------")
	print("Name: ", state.data.name)
	print("Type: ", state.data.type)

	# Cooking
	print("Cookable: ", state.data.cookable)
	if state.data.cookable:
		print("Cook Level: ", state.cook_level)

	# Chopping
	print("Cuttable: ", state.data.cuttable)
	if state.data.cuttable:
		print("Chop Level: ", state.chop_level)

	# Cleaning
	print("Cleanable: ", state.data.cleanable)
	if state.data.cleanable:
		print("Is Clean: ", state.is_clean)

	# Freezing
	print("Is Frozen: ", state.is_frozen)

	# Optional timing data (only if present)
	if state.data.has_method("get_cooking_time"):
		print("Cooking Time: ", state.data.cooking_time)

	print("---------------------------------")
