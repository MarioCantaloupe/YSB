extends Control

var NextScene = "res://02_scenes/04_screens/screen_mainMenu.tscn"
@onready var logo: AnimatedSprite2D = $Logo

@export var bite_audio : AudioStream

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	title_bounce()
	await get_tree().create_timer(2).timeout
	SceneLoader.load_scene(NextScene, SceneLoader.Transition.FADE)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		SceneLoader.load_scene(NextScene, SceneLoader.Transition.FADE)

func title_bounce():
	
	await get_tree().create_timer(1).timeout
	logo.play("bite")
	AudioManager.play_oneshot(bite_audio, 0, 1, 0, AudioManager.Bus.UI)
	logo.scale = Vector2(0.8, 0.4)
	var tween : Tween = create_tween()
	tween.tween_property(logo, "scale", Vector2(0.6,0.6), 0.5
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	await tween.finished
	
	
