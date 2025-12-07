extends ProgressBar

var duration := 3.0
var tween: Tween

func start_loop():
	# Cancel old tween if it exists
	if tween and tween.is_running():
		tween.kill()

	# Reset starting point
	value = 0

	# Make a fresh tween
	tween = create_tween()
	tween.tween_property(self, "value", 100, duration)
	tween.tween_callback(start_loop)  # loop again
