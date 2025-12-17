extends Node2D

@onready var station: Node2D = $station
@onready var mode_switch: Button = $mode_switch
@onready var tap_vfx: Sprite2D = $tap_vfx

@onready var debug_text: Label = $debug_text

@export var water_texture : Texture2D
@export var fire_texture : Texture2D


func _ready() -> void:
	tap_vfx.hide()

func _on_mode_switch_pressed() -> void:
	
	if station.action == 2:
		station.action = 3
		debug_text.text = "Descongelar"
	elif station.action == 3:
		station.action = 2
		debug_text.text = "Limpiar"
	
	
func enable_fire(value):
	if station.action == 3:
		tap_vfx.texture = fire_texture
		if value == true:
			tap_vfx.show()
		else:
			tap_vfx.hide()
	
func enable_water(value):
	if station.action == 2:
		tap_vfx.texture = water_texture
		if value == true:
			tap_vfx.show()
		else:
			tap_vfx.hide()
