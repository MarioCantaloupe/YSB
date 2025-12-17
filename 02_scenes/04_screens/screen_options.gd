extends Control

signal exited
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("options_popup")

func _on_button_exit_pressed() -> void:
	animation_player.play_backwards("options_popup")
	await animation_player.animation_finished
	exited.emit()
