extends Node2D
class_name LevelScene

@export var can_pause : bool
@onready var pause_canvas_layer: CanvasLayer = $pause_canvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if can_pause:
		pause_canvas_layer.visible = true
