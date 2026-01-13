extends LevelScene

@onready var tip_box: GameTipPanel = %TipBox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameSystem.GameState = GameSystem.GameStates.Cooking
	tip_box.tip_box_clicked.connect(tip_shown)
	
	MusicPlayer.play_music(preload("res://01_assets/03_sound/music/Cooking_theme.mp3"))
	
	if not GameSystem.cooking_tip_shown:
		await get_tree().create_timer(3).timeout
		tip_box.show_tip()

func tip_shown():
	GameSystem.cooking_tip_shown = true
