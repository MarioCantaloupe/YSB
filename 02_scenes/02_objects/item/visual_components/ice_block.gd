extends Sprite2D

@export var full_texture : Texture2D
@export var melted_texture : Texture2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture = full_texture
	
func melt():
	texture = melted_texture
