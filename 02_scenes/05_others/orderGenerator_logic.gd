extends Node

var max_drink_size : int = 3
var max_bocata_size : int = 5
var max_size_var : int = 2
var bocata_size : int = 0
var bocata_ingredients : Array[ItemState] = []
var drink_ingredients : Array[ItemState] = []

func add_random_item_to_bocata(bread_weight: int, meat_weight: int, veggie_weight: int, fluid_weight: int):
	
	# random state generator init
	var generator = RandomItemStateGenerator.new()
	generator._init()
	generator.weight_config = IngredientWeightConfig.new()
	
	# setting random chances
	generator.frozen_chance = 0
	generator.clean_chance = 1
	generator.weight_config.bread = bread_weight
	generator.weight_config.meat = meat_weight
	generator.weight_config.vegetable = veggie_weight
	generator.weight_config.fluid = fluid_weight
	
	
	# adding state to ingredient list
	bocata_ingredients.append(generator.generate_item_state())
	bocata_size = bocata_ingredients.size()
	
	print(bocata_ingredients)
	print("current bocata size: " + str(bocata_size))


func build_bocata():
	bocata_ingredients.clear()
	
	var final_size := max_bocata_size + randi_range(-max_size_var, max_size_var)
	final_size = max(final_size, 0)
	
	
	
	for ingredient in final_size:
		if ingredient == 0 or ingredient == final_size-1: # edges of bocata
			add_random_item_to_bocata(100,1,1,1)
		else: # inside bocata
			add_random_item_to_bocata(10,100,100,1)

func add_random_item_to_drink(bread_weight: int, meat_weight: int, veggie_weight: int, fluid_weight: int):
	
	# random state generator init
	var generator = RandomItemStateGenerator.new()
	generator._init()
	generator.weight_config = IngredientWeightConfig.new()
	
	# setting random chances
	generator.frozen_chance = 0
	generator.clean_chance = 1
	generator.weight_config.bread = bread_weight
	generator.weight_config.meat = meat_weight
	generator.weight_config.vegetable = veggie_weight
	generator.weight_config.fluid = fluid_weight
	
	
	# adding state to ingredient list
	drink_ingredients.append(generator.generate_item_state())
	
	print(bocata_ingredients)
	print("current bocata size: " + str(bocata_size))

func build_drink(): 	
	drink_ingredients.clear()
	var drink_size : int = max_drink_size + randi_range(-max_size_var, max_size_var)
	
	for ingredient in drink_size:
		add_random_item_to_drink(1,15,24,60)
