extends LevelScene

@onready var tip_box: GameTipPanel = %TipBox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tip_box.tip_box_clicked.connect(tip_shown)
	
	if not GameSystem.blending_tip_shown:
		await get_tree().create_timer(3).timeout
		tip_box.show_tip()

func tip_shown():
	GameSystem.blending_tip_shown = true
