extends Control

signal exited
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var panel_derecho: Control = $Panel3/PanelDerecho

const SOUND_PANEL = preload("res://02_scenes/04_screens/options_sound.tscn")
const SCREEN_PANEL = preload("res://02_scenes/04_screens/options_screen.tscn")
const CREDITS_PANEL = preload("res://02_scenes/04_screens/options_credits.tscn")

var current_panel: Control = null

func _ready() -> void:
	animation_player.play("options_popup")
	show_panel(SOUND_PANEL) # Panel por defecto

func _on_button_exit_pressed() -> void:
	animation_player.play_backwards("options_popup")
	await animation_player.animation_finished
	exited.emit()

func show_panel(panel_scene: PackedScene):
	if current_panel:
		current_panel.queue_free()

	current_panel = panel_scene.instantiate()
	panel_derecho.add_child(current_panel)
	

func _on_button_sound_panel_pressed() -> void:
	show_panel(SOUND_PANEL)

func _on_button_screen_panel_pressed() -> void:
	show_panel(SCREEN_PANEL)

func _on_button_credits_panel_pressed() -> void:
	show_panel(CREDITS_PANEL)
