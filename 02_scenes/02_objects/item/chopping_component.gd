extends Node2D

@export var slices_per_level : int = 5
@onready var knife_tutorial: AnimatedSprite2D = $knife_tutorial

signal chop_up(new_level: int)
signal knife_slip()

@onready var bottom_cut_zone: Area2D = $bottomCut_zone
@onready var top_cut_zone: Area2D = $topCut_zone
@export var chop_audio : AudioStream

var mouse_hovering : bool = false
var chopping : bool = false
var chop_isTop : bool = false 
var slice_count : int = 0
var chop_level : int = 0

var has_shown_tutorial : bool = false


func _ready() -> void:
	bottom_cut_zone.monitoring = false
	top_cut_zone.monitoring = false

func _process(_delta: float) -> void:
	if Input.is_action_just_released("Lclick"):
		chopping = false
		bottom_cut_zone.monitoring = false
		top_cut_zone.monitoring = false
		slice_count = 0
	if slice_count >= slices_per_level:
		chop_level_up()

func chop_level_up():
	chop_level += 1
	emit_signal("chop_up", chop_level)
	slice_count = 0
	chopping = false #prevent overchopping

#Mouse over activation
func _on_activation_zone_mouse_entered() -> void:
	mouse_hovering = true
	if PlayerCursor.is_knife and not has_shown_tutorial:
				knife_tutorial.show()
				has_shown_tutorial = true
func _on_activation_zone_mouse_exited() -> void:
	mouse_hovering = false
	


func _on_activation_zone_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if PlayerCursor.is_knife:
		if Input.is_action_just_pressed("Lclick"):
			chopping = true
			knife_tutorial.hide()
			bottom_cut_zone.monitoring = true
			top_cut_zone.monitoring = true


func _on_bottom_cut_zone_mouse_entered() -> void:
	if chopping:
		if chop_isTop:
			slice_count += 1
			chop_isTop = false
			AudioManager.play_oneshot(chop_audio, 0, 1 + (float(slice_count) / slices_per_level)*0.5, 0, AudioManager.Bus.SFX)


func _on_top_cut_zone_mouse_entered() -> void:
	if chopping:
		if not chop_isTop:
			slice_count += 1
			chop_isTop = true
			AudioManager.play_oneshot(chop_audio, 0, 1 + (float(slice_count) / slices_per_level)*0.5, 0, AudioManager.Bus.SFX)



func _on_side_zone_mouse_entered() -> void:
	if chopping:
		emit_signal("knife_slip")
	chopping = false
	slice_count = 0
