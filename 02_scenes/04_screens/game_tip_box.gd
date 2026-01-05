extends Control
class_name GameTipPanel

signal tip_box_clicked

@export var slide_time : float = 0.7
@export var tip_data : GameTip
@onready var game_tip_icon: TextureRect = %GameTipIcon
@onready var game_tip_text: RichTextLabel = %GameTipText
@onready var game_tip_panel: PanelContainer = %GameTipPanel

@export_group("Audio")
@export var slide_audio : AudioStream
@export var click_audio : AudioStream

var panel_length : float

var tween_out : Tween
var tween_in : Tween

func _ready() -> void:
	panel_length = game_tip_panel.get_rect().size.x

func show_tip():
	game_tip_text.text = tip_data.text
	game_tip_icon.texture = tip_data.image
	
	tween_in = create_tween()
	tween_in.tween_property(game_tip_panel,
	"position:x", -panel_length,
	slide_time
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	
	AudioManager.play_oneshot(slide_audio, 1, 1, 0, AudioManager.Bus.UI)

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("Lclick"):
		tween_out = create_tween()
		tween_out.tween_property(game_tip_panel,
		"position:x", panel_length, slide_time
		).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
		emit_signal("tip_box_clicked")
		await tween_out.finished
		queue_free()
		
		
	
