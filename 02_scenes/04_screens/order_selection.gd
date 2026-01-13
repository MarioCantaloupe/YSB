extends Control
class_name OrderSelector

@onready var memory_notes_bar: MemoryNotesBar = %memory_notes_bar
@onready var ringer: Ringer = %Ringer

@onready var but_return: DynamicButton = %BUT_Return

@export var fade_in_audio : AudioStream
@export var fade_out_audio : AudioStream


var prepared_bocata : Array[ItemState]
var prepared_drink : Array[ItemState]


var tween_out : Tween
var tween_in : Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ringer.order_ready.connect(_appear)
	memory_notes_bar.connect("order_selected", order_selected_menu)
	but_return.pressed.connect(_play_exit_animation)

	hide()

func _play_exit_animation() -> void:
	AudioManager.play_oneshot(fade_out_audio, 0, 1, 0, AudioManager.Bus.UI)
	
	tween_out = create_tween()
	tween_out.set_parallel(true)
	tween_out.tween_property(self, "modulate:a", 0, 0.3)
	tween_out.tween_property(self, "scale", Vector2(0.7,0.7), 0.3)
	await tween_out.finished
	hide()
	
func _appear():
	AudioManager.play_oneshot(fade_in_audio, 0, 1, 0, AudioManager.Bus.UI)
	show()
	tween_in = create_tween()
	tween_in.set_parallel(true)
	tween_in.tween_property(self, "modulate:a", 1, 0.3)
	tween_in.tween_property(self, "scale", Vector2.ONE, 0.3
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func order_selected_menu(order_id : int):
	GameSystem.submit_order(order_id, prepared_bocata, prepared_drink)
	_play_exit_animation()

func set_prepared_order(bocata: Array[ItemState], drink: Array[ItemState]):
	prepared_bocata = bocata
	prepared_drink = drink
