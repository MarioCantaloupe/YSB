extends Resource
class_name FoodData

@export var id: String
@export var name: String
@export var average_color: Color

@export_group("Sprites")
@export var sprite_grid : Array[Array] = [
	[null, null, null],
	[null, null, null],
	[null, null, null]
]
