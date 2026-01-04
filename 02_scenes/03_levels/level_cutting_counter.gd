extends LevelScene

@onready var tip_box: GameTipPanel = %TipBox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not GameSystem.cutting_tip_shown:
		await get_tree().create_timer(3).timeout
		tip_box.show_tip()
		GameSystem.cutting_tip_shown = true
