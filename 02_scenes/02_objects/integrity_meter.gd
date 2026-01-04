extends Node2D

@export var min_value : float = 17
@export var max_value : float = 85

@onready var progress_tank: TextureProgressBar = $TextureProgressBar
@onready var sound: AudioStreamPlayer2D = $sound

var mouse_to_meter : float


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	progress_tank.value = remap(GameSystem.spaceship_integrity, 0, 600, 17, 85)
	
	
	mouse_to_meter = global_position.distance_to(get_global_mouse_position())
	sound.volume_db = remap(mouse_to_meter, 1400, 0, -48, 2)
