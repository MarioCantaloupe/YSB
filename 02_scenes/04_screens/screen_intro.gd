extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var NextScene = "res://02_scenes/04_screens/screen_mainMenu.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("logo_fade_in")
	await GlobalScript.wait(1.5)
	GlobalScript.change_scene(NextScene)
