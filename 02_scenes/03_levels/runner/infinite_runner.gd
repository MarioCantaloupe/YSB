extends LevelScene

@onready var player: Player = %YayaPlayer
@onready var texture_lung_bar: TextureProgressBar = %texture_lung_bar
@onready var tooltip_player: AnimationPlayer = $tooltip_player

@export var music_audio : AudioStream

var has_tooltip_appeared : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_music(music_audio, -6)
	
	GameSystem.GameState = GameSystem.GameStates.Runner
	PlayerCursor.enable_cursor(false)
	tooltip_player.play("control_tooltip_fadeIn")
	
	texture_lung_bar.max_value = player.lung_capacity
	texture_lung_bar.value = player.lung_capacity
	#lung_bar.max_value = player.lung_capacity
	#lung_bar.value = player.lung_capacity
	
func _process(_delta: float) -> void:
	#lung_bar.value = player.lung_capacity
	texture_lung_bar.value = player.lung_capacity
	if Input.is_action_just_pressed("jump") and not has_tooltip_appeared:
		tooltip_player.play_backwards("control_tooltip_fadeIn")
		has_tooltip_appeared = true
		
func _on_yaya_game_end() -> void:
	GameSystem.runner_button_shown = false
	PlayerCursor.enable_cursor(true)
	SceneLoader.load_scene("res://02_scenes/03_levels/level_cuttingCounter.tscn", SceneLoader.Transition.NONE)
