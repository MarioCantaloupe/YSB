extends Control

signal exited


func _on_button_exit_pressed() -> void:
	exited.emit()
