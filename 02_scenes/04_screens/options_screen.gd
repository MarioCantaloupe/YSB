extends Control


@onready var resolution_option: OptionButton = $VBoxContainer/OptionButton

# Lista de resoluciones permitidas
var resolutions := [
	Vector2i(1280, 720),
	Vector2i(1366, 768),
	Vector2i(1600, 900),
	Vector2i(1920, 1080),
	Vector2i(2560, 1440)
]

func _ready():
	populate_resolutions()
	select_current_resolution()

func populate_resolutions():
	resolution_option.clear()
	for res in resolutions:
		resolution_option.add_item("%d x %d" % [res.x, res.y])

func select_current_resolution():
	var current_size = DisplayServer.window_get_size()
	for i in resolutions.size():
		if resolutions[i] == current_size:
			resolution_option.select(i)
			return


func center_window(window_size: Vector2i):
	var screen_size = DisplayServer.screen_get_size()
	DisplayServer.window_set_position((screen_size - window_size) / 2)

func _on_option_button_item_selected(index: int):
	var res = resolutions[index]
	DisplayServer.window_set_size(res)
	center_window(res)
