extends Node2D

@onready var sprite: Sprite2D = $sprite
@onready var click_area: Area2D = $click_area

@export var ding_audio : AudioStream

var click_tween : Tween

func _on_click_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("Lclick"):
		AudioManager.play_oneshot(ding_audio, 0, 1, 0, AudioManager.Bus.SFX)
		sprite.scale.y = 0.7
		if click_tween:
			click_tween.kill()
		click_tween = create_tween()
		click_tween.tween_property(sprite,"scale:y",1,0.2
		).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
		#TODO add order finished logic
