extends Node2D
class_name IntegrityMeter

@export var stable_audio : AudioStream
@export var unstable_audio : AudioStream

@onready var progress_tank: TextureProgressBar = $TextureProgressBar
@onready var sound: AudioStreamPlayer2D = $sound

var mouse_to_meter : float

func _ready() -> void:
	GameSystem.connect("order_result", visual_feedback)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	progress_tank.value = remap(GameSystem.spaceship_integrity, 0, GameSystem.MAX_SPACESHIP_INTEGRITY, 0, 100)
	
	mouse_to_meter = global_position.distance_to(get_global_mouse_position())
	sound.volume_db = remap(mouse_to_meter, 1400, 0, -48, -6)

func visual_feedback(is_good: bool):
	match is_good:
		true:
			#TODO green fucking overlay and shiz with money sound
			AudioManager.play_oneshot(stable_audio, 0, 1, 0, AudioManager.Bus.SFX)
			var tween_good : Tween = create_tween()
			tween_good.tween_property(progress_tank, "tint_progress", Color(0.541, 1.825, 0.15, 1.0), 1)
			tween_good.tween_property(progress_tank, "tint_progress", Color(1.825, 0.708, 0.15), 1)
		false:
			#TODO big fucking X onscreen and everything turns black and white and dark with loud wrong buzzer
			AudioManager.play_oneshot(unstable_audio, 0, 1, 0, AudioManager.Bus.SFX)
			var tween_bad : Tween = create_tween()
			for loop in 3:
				tween_bad.tween_property(progress_tank, "tint_progress", Color(1.825, 0.15, 0.15, 1.0), .1)
				tween_bad.tween_property(progress_tank, "tint_progress", Color(1.825, 0.708, 0.15), .1)
