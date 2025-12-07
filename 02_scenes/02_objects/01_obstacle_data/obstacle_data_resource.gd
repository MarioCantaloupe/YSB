extends Resource
class_name ObstacleData


@export var name: String
@export var movement_speed : float = 10 
@export var min_loot : int
@export var max_loot : int

var loot_amount : int = randi_range(min_loot, max_loot)

@export var sprite : Texture2D
