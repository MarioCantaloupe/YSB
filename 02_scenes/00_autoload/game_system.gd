extends Node

signal new_note(order : OrderData)
signal order_accepted(order : OrderData)
signal order_submitted(order_id: int, bocata: Array[ItemState], drink: Array[ItemState]) #unused
signal order_completed(order_id : int)
signal order_result(result : bool)

const MAX_SPACESHIP_INTEGRITY : float = 720
var spaceship_integrity : float = 720
const INTEGRITY_LOSS_RATE : float = 1
const ORDER_INTEGRITY_DELTA : float = 60.0
const ORDER_SUCCESS_THRESHOLD := 40

var game_started : bool = false
#var drinks_unlocked : bool = false

# GAME STATE
enum GameStates{
	Orders,
	Cutting,
	Cooking,
	Finalizing,
	Runner,
}

var GameState : GameStates


# GAME TIPS
var game_tip_scene : String = "res://02_scenes/04_screens/game_tip_box.tscn"
var orders_tip_shown : bool = false
var cutting_tip_shown : bool = false
var cooking_tip_shown : bool = false
var blending_tip_shown : bool = false
var stacking_tip_shown : bool = false
var ringer_tip_shown : bool = false


# ORDER CREATION

var base_order_interval : float = 30 #base interval between orders
var min_order_interval : float = 2 #minimum interval between orders
var difficulty_ramp_rate : float = 0.8 #interval time decrease per order

var _order_timer: float = 0
var _current_order_interval : float = 1.0

var first_order_spawned : bool = false
var first_order_taken : bool = false

# FOR CONTINUITY
# ORDERS
var pending_orders : Array[OrderData] = []
var active_orders : Array[OrderData] = []
var next_order_id : int = 1
var max_active_orders : int = 10
var music_started : bool = false

# ORDER SCREEN
var occupied_slots : Array[int] = [] # order_id, -1 = empty
var max_notes_on_string : int = 5

# BLENDER SCREEN
var ingredient_states_in_blender : Array [ItemState] = []
var blender_fluid_color : Color = Color(1.0, 1.0, 1.0, 0.0)

var runner_button_shown : bool

func _ready() -> void:
	spaceship_integrity = MAX_SPACESHIP_INTEGRITY
	
	if occupied_slots.is_empty():
		occupied_slots.resize(5)
		occupied_slots.fill(-1)


func create_order() -> OrderData:
	if pending_orders.size() >= max_active_orders:
		return null
	
	if occupied_slots.count(-1) == 0:
		return null
	
	var order := OrderData.new()
	order.order_id = next_order_id
	next_order_id += 1

	order.creation_time = Time.get_ticks_msec()

	var generator := OrderGenerator.new()
	order.bocata_ingredients = generator.build_bocata()
	order.drink_ingredients = generator.build_drink()

	pending_orders.append(order)


	var slot_index := _get_random_free_slot_index()
	if slot_index != -1:
		occupied_slots[slot_index] = order.order_id

	emit_signal("new_note", order)
	var newOrder_audio : AudioStream = preload("res://01_assets/03_sound/new_order.ogg")
	AudioManager.play_oneshot(newOrder_audio, 0, 1, 0, AudioManager.Bus.SFX)

	return order





func accept_order(id : int) -> void:
	var order := get_pending_order(id)
	if order == null:
		return

	pending_orders.erase(order)
	active_orders.append(order)

	# CHANGE START: Clear the slot immediately
	for i in range(max_notes_on_string):
		if occupied_slots[i] == id:
			occupied_slots[i] = -1
			break
	# CHANGE END

	order.taken_time = Time.get_ticks_msec()
	emit_signal("order_accepted", order)
	print("GameSystem: Order #", id, " accepted")



func submit_order(order_id : int, bocata: Array[ItemState], drink: Array[ItemState]):
	var expected : OrderData = get_active_order(order_id)
	if expected == null:
		print_debug("Expected order is NULL")
		return
	
	var given : OrderData = OrderData.new()
	given.bocata_ingredients = bocata
	given.drink_ingredients = drink
	
	var score : int = OrderMatcher.match_order_simple(given, expected)
	
	apply_order_result(order_id, score)

func complete_order(order_id : int) -> void:
	for order in active_orders:
		if order.order_id == order_id:
			active_orders.erase(order)
			emit_signal("order_completed", order_id)
			print("GameSystem: Order #", order_id, " completed")
			return

# helpers
func get_pending_order(id : int) -> OrderData:
	for order in pending_orders:
		if order.order_id == id:
			return order
	return null
	
func get_active_order(id: int) -> OrderData:
	for order in active_orders:
		if order.order_id == id:
			return order
	return null

func _update_order_spawning(delta: float) -> void:
	if pending_orders.size() >= max_active_orders:
		return

	if occupied_slots.count(-1) == 0:
		return

	var spawn_multiplier := 1.0
	match GameState:
		GameStates.Runner:
			spawn_multiplier = 0.0 # no notes spawn when in runner
		GameStates.Cutting, GameStates.Cooking:
			spawn_multiplier = 1.2

	_order_timer += delta * spawn_multiplier

	if _order_timer >= _current_order_interval:
		_order_timer = 0.0

		create_order()

		if not first_order_spawned:
			first_order_spawned = true
			_current_order_interval = base_order_interval
		else:
			_current_order_interval = max(
				min_order_interval,
				_current_order_interval - difficulty_ramp_rate
			)

func _get_random_free_slot_index() -> int:
	var free_indices: Array[int] = []
	for i in range(max_notes_on_string):
		if occupied_slots[i] == -1:
			free_indices.append(i)
	
	if free_indices.is_empty():
		return -1
		
	return free_indices.pick_random()



func _update_integrity(delta: float) -> void:
	match GameState:
		GameStates.Runner:
			spaceship_integrity -= INTEGRITY_LOSS_RATE * delta * 0.20 # time dilation bruhaps??
		GameStates.Finalizing:
			spaceship_integrity -= INTEGRITY_LOSS_RATE * delta
		_:
			spaceship_integrity -= INTEGRITY_LOSS_RATE * delta * 0.85

	if spaceship_integrity <= 0:
		game_over()
	
func apply_order_result(order_id: int, score: int):
	var success : bool = score >= ORDER_SUCCESS_THRESHOLD
	
	var delta := ORDER_INTEGRITY_DELTA
	if not success:
		delta = -ORDER_INTEGRITY_DELTA
	
	if delta > 0:
		emit_signal("order_result", true)
	else:
		emit_signal("order_result", false)
		
	
	spaceship_integrity += delta
	spaceship_integrity = clamp(spaceship_integrity, 0 , MAX_SPACESHIP_INTEGRITY)
	print("Spaceship integrity was modified by ", delta)
	complete_order(order_id)



func start_game() -> void:
	game_started = true

func _process(delta : float) -> void:
	if get_tree().paused or not game_started:
		return
	
	_update_integrity(delta)
	_update_order_spawning(delta)

func game_over():
	spaceship_integrity = MAX_SPACESHIP_INTEGRITY
	pending_orders.clear()
	active_orders.clear()
	first_order_spawned = false
	_current_order_interval = 1.0
	_order_timer = 0.0
	
	occupied_slots.fill(-1)
	
	PantryInventory.inventory.clear()
	SceneLoader.load_scene("res://02_scenes/04_screens/screen_gameOver.tscn", SceneLoader.Transition.NONE, false)
