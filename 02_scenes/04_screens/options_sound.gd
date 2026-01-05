extends Control

@onready var master_slider: HSlider= %HSliderGeneral
@onready var music_slider: HSlider= %HSliderMusic
@onready var sfx_slider: HSlider= %HSliderSfx
@onready var interfaz_slider: HSlider= %HSliderInterfaz

const BUS_MASTER:= "Master"
const BUS_MUSIC:= "Music"
const BUS_SFX:= "SFX"
const BUS_INTERFAZ:= "UI"

func _ready():
	load_bus_volume(BUS_MASTER, master_slider)
	load_bus_volume(BUS_MUSIC, music_slider)
	load_bus_volume(BUS_SFX, sfx_slider)
	load_bus_volume(BUS_INTERFAZ, interfaz_slider)

func load_bus_volume(bus_name: String, slider: HSlider):
	var bus = AudioServer.get_bus_index(bus_name)
	slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus))

func set_bus_volume(bus_name: String, value: float):
	var bus = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))

func _on_h_slider_general_value_changed(value: float) -> void:
	set_bus_volume(BUS_MASTER, value)

func _on_h_slider_music_value_changed(value: float) -> void:
	set_bus_volume(BUS_MUSIC, value)

func _on_h_slider_sfx_value_changed(value: float) -> void:
	set_bus_volume(BUS_SFX, value)

func _on_h_slider_interfaz_value_changed(value: float) -> void:
	set_bus_volume(BUS_INTERFAZ, value)
