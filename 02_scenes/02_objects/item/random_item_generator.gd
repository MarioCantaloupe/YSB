extends Node
class_name RandomItemGenerator

const ITEM_DATA_PATH := "res://02_scenes/02_objects/00_item_data/"

var BreadWeight : int = 1
var MeatWeight : int = 1
var VegetableWeight : int = 1
var FluidWeight : int = 1

const STATE_CONFIG := {
	ItemData.IngredientType.BREAD: {
		"cook_range": Vector2i(0, 1),
		"chop_range": Vector2i(0, 0),
		"frozen_chance": 0.0,
		"clean_chance": 1.0
	},
	ItemData.IngredientType.MEAT: {
		"cook_range": Vector2i(0, 3),
		"chop_range": Vector2i(0, 2),
		"frozen_chance": 0.2,
		"clean_chance": 0.8
	},
	ItemData.IngredientType.VEGETABLE: {
		"cook_range": Vector2i(0, 2),
		"chop_range": Vector2i(0, 3),
		"frozen_chance": 0.1,
		"clean_chance": 0.6
	},
	ItemData.IngredientType.FLUID: {
		"cook_range": Vector2i(0, 1),
		"chop_range": Vector2i(0, 0),
		"frozen_chance": 0.05,
		"clean_chance": 1.0
	}
}

func _ready() -> void:
	_load_item_data()
	
	print("Weights in editor: ", get_weights_dict())

func create_random_ingredient():
	randomize()
	_load_item_data()
	print("Loaded ItemData by type:", item_data_by_type)
	
	var item_state := generate_random_item_state(get_weights_dict())
	print(item_state)
	

var item_data_by_type: Dictionary = {}


func _load_item_data() -> void:
	item_data_by_type.clear()
	
	var dir := DirAccess.open(ITEM_DATA_PATH)
	if dir == null:
		push_error("Item data directory not found")
		return
		
	dir.list_dir_begin()
	var file_name := dir.get_next()
	
	while file_name != "":
		if file_name.ends_with(".tres"):
			var res := load(ITEM_DATA_PATH + file_name)
			if res is ItemData:
				if not item_data_by_type.has(res.type):
					item_data_by_type[res.type] = []
				item_data_by_type[res.type].append(res)
		file_name = dir.get_next()

	dir.list_dir_end()
	
func get_random_item_data(weight_by_type: Dictionary) -> ItemData:
	var weighted_pool: Array[ItemData] = []

	for ingredient_type in weight_by_type.keys():
		if not item_data_by_type.has(ingredient_type):
			continue

		var weight: int = weight_by_type[ingredient_type]
		var items: Array = item_data_by_type[ingredient_type]

		for i in range(weight):
			for item in items:
				weighted_pool.append(item)

	if weighted_pool.is_empty():
		return null
	
	print("Weighted pool size:", weighted_pool.size())

	return weighted_pool.pick_random()

func generate_random_item_state(weight_by_type: Dictionary) -> ItemState:
	var item_data := get_random_item_data(weight_by_type)
	if item_data == null:
		return null

	var config = STATE_CONFIG[item_data.type]

	var state := ItemState.new()
	state.data = item_data

	# Cook level
	if item_data.cookable:
		state.cook_level = randi_range(
			config.cook_range.x,
			config.cook_range.y
		)

	# Chop level
	if item_data.cuttable:
		state.chop_level = randi_range(
			config.chop_range.x,
			config.chop_range.y
		)

	# Frozen
	state.is_frozen = randf() < config.frozen_chance

	# Clean
	if item_data.cleanable:
		state.is_clean = randf() < config.clean_chance

	return state

func get_weights_dict() -> Dictionary:
	return {
		ItemData.IngredientType.BREAD: BreadWeight,
		ItemData.IngredientType.MEAT: MeatWeight,
		ItemData.IngredientType.VEGETABLE: VegetableWeight,
		ItemData.IngredientType.FLUID: FluidWeight
	}
