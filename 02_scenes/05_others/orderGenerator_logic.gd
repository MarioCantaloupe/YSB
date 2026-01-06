extends Node
class_name OrderGenerator

var max_drink_size : int = 3
var max_bocata_size : int = 5
var max_size_var : int = 2


func _create_generator(bread_weight: int, meat_weight: int, veggie_weight: int, fluid_weight: int) -> RandomItemStateGenerator:
	var generator := RandomItemStateGenerator.new()
	generator._init()
	generator.weight_config = IngredientWeightConfig.new()

	generator.frozen_chance = 0
	generator.clean_chance = 1
	generator.weight_config.bread = bread_weight
	generator.weight_config.meat = meat_weight
	generator.weight_config.vegetable = veggie_weight
	generator.weight_config.fluid = fluid_weight

	return generator


func build_bocata() -> Array[ItemState]:
	var bocata_ingredients : Array[ItemState] = []

	var final_size : int = max_bocata_size + randi_range(-max_size_var, max_size_var)
	if final_size < 0:
		final_size = 0

	for i in range(final_size):
		var generator : RandomItemStateGenerator
		if i == 0 or i == final_size - 1:
			generator = _create_generator(100, 1, 1, 1)
		else:
			generator = _create_generator(10, 100, 100, 1)

		bocata_ingredients.append(generator.generate_item_state())

	return bocata_ingredients


func build_drink() -> Array[ItemState]:
	var drink_ingredients : Array[ItemState] = []

	var drink_size : int = max_drink_size + randi_range(-max_size_var, max_size_var)
	if drink_size < 0:
		drink_size = 0

	for i in range(drink_size):
		var generator := _create_generator(1, 15, 24, 60)
		drink_ingredients.append(generator.generate_item_state())

	return drink_ingredients
