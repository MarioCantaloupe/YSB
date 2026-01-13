extends Node2D

@export var float_distance: float = 40.0
@export var duration: float = 0.8

@onready var label: Label = $Label

func setup(amount: int):
	label.text = "+" + str(amount) + "!"
	start_animation()

func start_animation():
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(
		self, "position:y", position.y - float_distance,duration
	)
	tween.tween_property(
		self, "modulate:a", 0.0, duration
	)
	tween.finished.connect(queue_free)
