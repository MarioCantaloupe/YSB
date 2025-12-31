extends Node2D

enum StationAction { NONE, COOK, CLEAN, DEFROST }

@export var action: StationAction = StationAction.NONE

signal station_selected(bool)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if action == StationAction.NONE:
		pass


func _on_drop_zone_zone_selected(state):
	emit_signal("station_selected", state)
	if state == true:
		if action == StationAction.DEFROST:
			get_parent().enable_fire(true)
		elif action == StationAction.CLEAN:
			get_parent().enable_water(true)
	else:
		if action == StationAction.DEFROST:
			get_parent().enable_fire(false)
		elif action == StationAction.CLEAN:
			get_parent().enable_water(false)
