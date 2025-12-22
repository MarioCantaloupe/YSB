extends Node

var bocata_size : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func create_item(bread_weight: int, meat_weight: int, veggie_weight: int, fluid_weight: int):
	
	# random state generator init
	var generator = RandomItemStateGenerator.new()
	generator.weight_config = IngredientWeightConfig.new()
	generator.weight_config.bread = bread_weight
	generator.weight_config.meat = meat_weight
	generator.weight_config.vegetable = veggie_weight
	generator.weight_config.fluid = fluid_weight
	
	# creating state
	var new_item = Item.new()
	new_item.apply_item_state(generator.generate_item_state())
	bocata_size += 1
