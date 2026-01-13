extends Node2D
class_name IntegrityMeter

@export var min_value : float = 17
@export var max_value : float = 85

@export var stable_audio : AudioStream
@export var unstable_audio : AudioStream

@onready var progress_tank: TextureProgressBar = $TextureProgressBar
@onready var sound: AudioStreamPlayer2D = $sound

var mouse_to_meter : float


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	progress_tank.value = remap(GameSystem.spaceship_integrity, 0, GameSystem.MAX_SPACESHIP_INTEGRITY, 17, 85)
	
	
	mouse_to_meter = global_position.distance_to(get_global_mouse_position())
	sound.volume_db = remap(mouse_to_meter, 1400, 0, -48, -6)

static func visual_feedback(is_good: bool):
	match is_good:
		true:
			pass #TODO green fucking overlay and shiz with money sound
		false:
			pass #TODO big fucking X onscreen and everything turns black and white and dark with loud wrong buzzer
	
