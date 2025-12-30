extends Node2D

@export var move_distance := 40.0
@export var move_time := 0.4
@export var hold_time := 1.0
@export var return_time := 0.3

@onready var item_label: Label = $item_label
@onready var og_pos : Vector2 = position

var tween_up : Tween
var tween_down : Tween

func _ready() -> void:
	hide()

func play_popup(text : String):
	show()
	if tween_up or tween_down:
		if tween_up.is_running() or tween_down.is_running():
			print("not playing tween")
			return
		
	
	item_label.text = text
	
	var start_pos := position
	var start_scale := scale

	tween_up = create_tween()

	# ───── STEP 1: UP (PARALLEL) ─────
	tween_up.set_parallel(true)

	tween_up.tween_property(
		self,
		"position",
		start_pos + Vector2(0, -move_distance),
		move_time
	).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

	tween_up.tween_property(
		self,
		"scale",
		start_scale * 1.2,
		move_time
	).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)

	tween_up.tween_property(
		self,
		"modulate:a",
		1.0,
		move_time
	).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

	# ───── STEP 2: HOLD ─────
	tween_up.chain()
	await tween_up.tween_interval(hold_time).finished


	# ───── STEP 3: DOWN (PARALLEL) ─────
	tween_down = create_tween()
	tween_down.set_parallel(true)

	tween_down.tween_property(
		self,
		"position",
		start_pos,
		return_time
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)

	tween_down.tween_property(
		self,
		"scale",
		start_scale,
		return_time
	)

	tween_down.tween_property(
		self,
		"modulate:a",
		0.0,
		return_time
	)
