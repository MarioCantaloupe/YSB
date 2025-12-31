extends Sprite2D

@export var bus_variants : Array[Texture2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture = bus_variants.pick_random()
