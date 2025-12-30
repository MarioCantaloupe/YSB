extends Resource
class_name ObstacleData


@export var name: String
@export var movement_speed : float = 10 
@export var min_loot : int
@export var max_loot : int
@export var hit_sound : AudioStream
@export var size_variance : float = 0

var loot_amount : int = randi_range(min_loot, max_loot)
	
@export var sprite : Texture2D
