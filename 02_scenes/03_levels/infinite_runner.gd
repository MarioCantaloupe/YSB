extends Node2D

@onready var player: Player = $yaya
@onready var lung_bar: ProgressBar = $UI/VBoxContainer/lung_bar
@onready var tooltip_player: AnimationPlayer = $tooltip_player

var has_tooltip_appeared : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerCursor.enable_cursor(false)
	tooltip_player.play("control_tooltip_fadeIn")
	
	lung_bar.max_value = player.lung_capacity
	lung_bar.value = player.lung_capacity

func _process(_delta: float) -> void:
	lung_bar.value = player.lung_capacity
	if Input.is_action_just_pressed("jump") and not has_tooltip_appeared:
		tooltip_player.play_backwards("control_tooltip_fadeIn")
		has_tooltip_appeared = true
		

func _on_yaya_game_end() -> void:
	PlayerCursor.enable_cursor(true)
	GlobalScript.change_scene(GlobalScript.Kitchen01)
	
