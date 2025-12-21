extends Resource
class_name IngredientWeightConfig

@export var bread: int = 1
@export var meat: int = 1
@export var vegetable: int = 1
@export var fluid: int = 1

func get_weight(type: ItemData.IngredientType) -> int:
	match type:
		ItemData.IngredientType.BREAD:
			return bread
		ItemData.IngredientType.MEAT:
			return meat
		ItemData.IngredientType.VEGETABLE:
			return vegetable
		ItemData.IngredientType.FLUID:
			return fluid
		_:
			return 0
