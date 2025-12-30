extends CanvasLayer

@onready var rect : ColorRect = $ColorRect

const FADE_TIME := 0.3
const SLIDE_TIME := 0.4

func fade_in() -> void:
	rect.modulate.a = 1.0

	var tween = create_tween()
	tween.tween_property(rect, "modulate:a", 0.0, FADE_TIME)
	tween.tween_callback(queue_free)

func fade_out(on_finished : Callable) -> void:
	rect.modulate.a = 0.0

	var tween = create_tween()
	tween.tween_property(rect, "modulate:a", 1.0, 0.3)
	tween.tween_callback(on_finished)
	tween.tween_callback(queue_free)

func slide_in(direction : int) -> void:
	var size = get_viewport().get_visible_rect().size
	var end_pos := Vector2.ZERO

	match direction:
		SceneLoader.Transition.SLIDE_LEFT:
			end_pos = Vector2(-size.x, 0)
		SceneLoader.Transition.SLIDE_RIGHT:
			end_pos = Vector2(size.x, 0)

	rect.position = Vector2.ZERO

	var tween = create_tween()
	tween.tween_property(rect, "position", end_pos, SLIDE_TIME)
	tween.tween_callback(queue_free)

func slide_out(direction : int, on_finished : Callable) -> void:
	var size = get_viewport().get_visible_rect().size
	var start_pos = Vector2.ZERO
	var end_pos = Vector2.ZERO

	match direction:
		SceneLoader.Transition.SLIDE_LEFT:
			start_pos = Vector2(size.x, 0)
		SceneLoader.Transition.SLIDE_RIGHT:
			start_pos = Vector2(-size.x, 0)

	rect.position = start_pos

	var tween = create_tween()
	tween.tween_property(rect, "position", end_pos, 0.4)
	tween.tween_callback(on_finished)
	tween.tween_callback(queue_free)
