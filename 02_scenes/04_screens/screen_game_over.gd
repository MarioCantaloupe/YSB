extends Control

@onready var black_fade_in: ColorRect = $BlackFadeIn
@export var outage_audio : AudioStream

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.stop_music()
	black_fade_in.show()
	AudioManager.play_oneshot(outage_audio, -6, 1, 0, AudioManager.Bus.SFX)
	await get_tree().create_timer(1).timeout
	var tween_in : Tween = create_tween()
	tween_in.tween_property(black_fade_in, "self_modulate:a",0,1)
