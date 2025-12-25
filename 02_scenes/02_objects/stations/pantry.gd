extends Control

@onready var tab_container: TabContainer = $TabContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tab_container.current_tab = PantryInventory.open_tab


func _on_panes_tab_button_pressed(tab: int) -> void:
	PantryInventory.open_tab = tab
	print("tab clicked")


func _on_carnes_tab_button_pressed(tab: int) -> void:
	PantryInventory.open_tab = tab
	print("tab clicked")


func _on_vegetales_tab_button_pressed(tab: int) -> void:
	PantryInventory.open_tab = tab
	print("tab clicked")


func _on_líquidos_tab_button_pressed(tab: int) -> void:
	PantryInventory.open_tab = tab
	print("tab clicked")
