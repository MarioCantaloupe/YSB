extends Node2D

@onready var tap_sprite: Sprite2D = $tap
@onready var station: Node2D = $station
@onready var mode_switch: Button = $mode_switch
@onready var vfx: AnimatedSprite2D = $vfx

@export var water_tap : Texture2D
@export var fire_tap : Texture2D
@export var water_texture : Texture2D
@export var fire_texture : Texture2D

@export var switch_audio : AudioStream
@export var water_audio : AudioStream
@export var fire_audio : AudioStream

func _ready() -> void:
	#tap_vfx.hide()
	vfx.hide()

func _on_mode_switch_pressed() -> void:
	
	if station.action == station.StationAction.CLEAN:
		station.action = station.StationAction.DEFROST
		tap_sprite.texture = fire_tap
	elif station.action == station.StationAction.DEFROST:
		station.action = station.StationAction.CLEAN
		tap_sprite.texture = water_tap
	
	AudioManager.play_oneshot(switch_audio, 0, 1, 0, AudioManager.Bus.SFX)
	
	
func enable_fire(value):
	if station.action == station.StationAction.DEFROST:
		vfx.play("fire")
		if value == true:
			vfx.show()
		else:
			vfx.hide()
	
func enable_water(value):
	if station.action == station.StationAction.CLEAN:
		vfx.play("water")
		if value == true:
			vfx.show()
		else:
			vfx.hide()
