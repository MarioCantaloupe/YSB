extends Node2D

enum StationAction { NONE, COOK, CLEAN, DEFROST }

@export var action: StationAction = StationAction.NONE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if action == StationAction.NONE:
		pass
