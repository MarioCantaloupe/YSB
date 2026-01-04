extends Control

@onready var tab_container: TabContainer = $TabContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tab_container.current_tab = PantryInventory.open_tab
	tab_container.connect("mouse_entered", _mouse_in_pantry)
	tab_container.connect("mouse_exited", _mouse_out_pantry)

func _mouse_in_pantry():
	if not PlayerCursor.is_knife and not PlayerCursor.held_item:
		PlayerCursor.set_cursor(PlayerCursor.CursorType.CAN_INTERACT)
	
func _mouse_out_pantry():
	if not PlayerCursor.is_knife and not PlayerCursor.held_item:
		PlayerCursor.set_cursor(PlayerCursor.CursorType.POINT)
