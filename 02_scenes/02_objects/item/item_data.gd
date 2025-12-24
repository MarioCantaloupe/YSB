extends Resource
class_name ItemData

@export var id: String
@export var name: String
@export var average_color: Color
@export var type : IngredientType
@export var cooking_time : float = 3.0
@export var ingredient_height_ch00 : int #in pixels, for positioning other ingredients
@export var ingredient_height_ch01 : int
@export var ingredient_height_ch02 : int

@export var cookable : bool
@export var cleanable : bool
@export var cuttable : bool

enum IngredientType {
	BREAD,
	MEAT,
	VEGETABLE,
	FLUID,
}

@export_group("Sprites")
@export var sprite_grid : Array[Array] = [
	[null, null, null],
	[null, null, null],
	[null, null, null]
]
