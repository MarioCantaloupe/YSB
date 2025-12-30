extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var NextScene = "res://02_scenes/04_screens/screen_mainMenu.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("logo_fade_in")
	await animation_player.animation_finished
	await get_tree().create_timer(1.5).timeout
	SceneLoader.load_scene(NextScene, SceneLoader.Transition.FADE)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		SceneLoader.load_scene(NextScene, SceneLoader.Transition.FADE)
