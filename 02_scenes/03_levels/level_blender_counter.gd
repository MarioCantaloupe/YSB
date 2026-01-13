extends LevelScene

@onready var tip_box: GameTipPanel = %TipBox
@onready var ringer: Node2D = %Ringer
@onready var blender: Blender = $WorldItems/blender
@onready var stacking_plate: StackingPlate = $stacking_plate
@onready var order_selection: OrderSelector = %order_selection


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameSystem.GameState = GameSystem.GameStates.Finalizing
	tip_box.tip_box_clicked.connect(tip_shown)
	
	if not GameSystem.blending_tip_shown:
		await get_tree().create_timer(3).timeout
		tip_box.show_tip()
func tip_shown():
	GameSystem.blending_tip_shown = true
	


func _on_ringer_order_ready() -> void:
	var final_bocata : Array[ItemState] = blender.finish_drink()
	var final_drink : Array[ItemState] = stacking_plate.finish_bocata()
	
	order_selection.set_prepared_order(final_bocata, final_drink)
	
