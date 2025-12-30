extends Node2D

@onready var tap_sprite: Sprite2D = $tap
@onready var station: Node2D = $station
@onready var mode_switch: Button = $mode_switch
@onready var vfx: AnimatedSprite2D = $vfx



@export var water_tap : Texture2D
@export var fire_tap : Texture2D
@export var water_texture : Texture2D
@export var fire_texture : Texture2D


func _ready() -> void:
	#tap_vfx.hide()
	vfx.hide()

func _on_mode_switch_pressed() -> void:
	
	if station.action == 2:
		station.action = 3
		tap_sprite.texture = fire_tap
	elif station.action == 3:
		station.action = 2
		tap_sprite.texture = water_tap
	
	
func enable_fire(value):
	if station.action == 3:
		vfx.play("fire")
		#tap_vfx.texture = fire_texture
		if value == true:
			#tap_vfx.show()
			vfx.show()
		else:
			#tap_vfx.hide()
			vfx.hide()
	
func enable_water(value):
	if station.action == 2:
		vfx.play("water")
		#tap_vfx.texture = water_texture
		if value == true:
			#tap_vfx.show()
			vfx.show()
		else:
			#tap_vfx.hide()
			vfx.hide()
