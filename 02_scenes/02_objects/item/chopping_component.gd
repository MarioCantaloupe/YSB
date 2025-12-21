extends Node2D

@export var slices_per_level : int = 5

signal chop_up(new_level: int)
signal knife_slip()

@onready var bottom_cut_zone: Area2D = $bottomCut_zone
@onready var top_cut_zone: Area2D = $topCut_zone


var mouse_hovering : bool = false
var chopping : bool = false
var chop_isTop : bool = false 
var slice_count : int = 0
var chop_level : int = 0


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
func _on_activation_zone_mouse_exited() -> void:
	mouse_hovering = false


func _on_activation_zone_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if PlayerCursor.is_knife:
		if Input.is_action_just_pressed("Lclick"):
			chopping = true
			bottom_cut_zone.monitoring = true
			top_cut_zone.monitoring = true


func _on_bottom_cut_zone_mouse_entered() -> void:
	if chopping:
		if chop_isTop:
			slice_count += 1
			chop_isTop = false


func _on_top_cut_zone_mouse_entered() -> void:
	if chopping:
		if not chop_isTop:
			slice_count += 1
			chop_isTop = true


func _on_side_zone_mouse_entered() -> void:
	if chopping:
		emit_signal("knife_slip")
	chopping = false
	slice_count = 0
