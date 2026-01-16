extends Node2D
class_name Ringer

signal order_ready

@onready var sprite: Sprite2D = $sprite
@onready var click_area: Area2D = $click_area
@onready var combo_timer: Timer = $combo_timer
@onready var tooltip: RichTextLabel = $tooltip
@export var ding_audio : AudioStream
@export var tooltip_audio : AudioStream
var ringer_level : int
var click_tween : Tween

var tooltween_up : Tween



func _on_click_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("Lclick"):
		
		ringer_level += 1
		combo_timer.start()
		
		#visual/audio feedback
		AudioManager.play_oneshot(ding_audio, 0, 1, 0, AudioManager.Bus.SFX)
		sprite.scale.y = 0.7
		if click_tween:
			click_tween.kill()
		click_tween = create_tween()
		click_tween.tween_property(sprite,"scale:y",1,0.2
		).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
		
		#order finished
		if ringer_level >= 3:
			if GameSystem.active_orders.is_empty():
				show_tip("[center]No hay pedidos![/center]")
				return
			print("Order is ready!")
			ringer_level = 0
			emit_signal("order_ready")
			GameSystem.ringer_tip_shown = true

func _on_combo_timer_timeout() -> void:
	if ringer_level >= 3:
		return
	
	ringer_level = 0
	
	if GameSystem.ringer_tip_shown:
		return
	
	show_tip("[center]3 para entregar[/center]")
	
func show_tip(tipText : String):
	tooltip.text = tipText
	AudioManager.play_oneshot(tooltip_audio, 0 ,1, 0, AudioManager.Bus.UI)
	#show tooltip
	tooltween_up = create_tween()
	tooltween_up.set_parallel(true)
	tooltween_up.tween_property(tooltip, "self_modulate:a",1,0.5
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tooltween_up.tween_property(tooltip, "position:y",-460,0.5
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	
	await get_tree().create_timer(0.75).timeout
	
	var tooltween_down : Tween = create_tween()
	tooltween_down.set_parallel(true)
	tooltween_down.tween_property(tooltip, "self_modulate:a",0,0.5
	).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	tooltween_down.tween_property(tooltip, "position:y",-260,0.5
	).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
