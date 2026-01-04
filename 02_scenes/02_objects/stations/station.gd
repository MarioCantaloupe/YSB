extends Node2D
class_name Station

enum StationAction { NONE, COOK, CLEAN, DEFROST }

@export var action: StationAction = StationAction.NONE

var drop_zone: Node2D

signal station_selected(state : bool, item : Item)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if action == StationAction.NONE:
		pass
	
	if $drop_zone:
		drop_zone = $drop_zone
		
	drop_zone.connect("zone_selected", _on_drop_zone_zone_selected)


func _on_drop_zone_zone_selected(state, item):
	emit_signal("station_selected", state, item)
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
