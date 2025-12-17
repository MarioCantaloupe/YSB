extends Sprite2D

@onready var ui_timer: Sprite2D = $ui_timer
var cooking_tween: Tween

func start_cooking_ui(cooking_time: float):
	# Kill any existing tween
	if cooking_tween and cooking_tween.is_running():
		cooking_tween.kill()

	# Hard reset to scale 1 BEFORE starting
	ui_timer.scale = Vector2.ONE

	cooking_tween = create_tween()
	cooking_tween.set_loops()

	cooking_tween.tween_property(
		ui_timer,
		"scale",
		Vector2.ZERO,
		cooking_time
	)

	cooking_tween.tween_callback(func():
		ui_timer.scale = Vector2.ONE
	)

func hide_cooking_ui(value: bool):
	if cooking_tween and cooking_tween.is_running():
		cooking_tween.kill()

	modulate.a = remap(value, 1, 0, 0, 255)
