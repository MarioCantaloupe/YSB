extends Node

signal new_note(order : OrderData)
signal order_accepted(order : OrderData)
signal order_completed(order_id : int)

const MAX_SPACESHIP_INTEGRITY : float = 720
var spaceship_integrity : float = 720
const INTEGRITY_LOSS_RATE : float = 1
var game_started : bool = false
var drinks_unlocked : bool = false

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


# FOR CONTINUITY
# ORDERS
var pending_orders : Array[OrderData] = []
var active_orders : Array[OrderData] = []
var next_order_id : int = 1
var max_active_orders : int = 10

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
	var order := OrderData.new()
	order.order_id = next_order_id
	next_order_id += 1

	order.creation_time = Time.get_ticks_msec()

	var generator := OrderGenerator.new()
	order.bocata_ingredients = generator.build_bocata()
	order.drink_ingredients = generator.build_drink()

	pending_orders.append(order)
	emit_signal("new_note", order)

	return order


func accept_order(id : int) -> void:
	var order := get_pending_order(id)
	if order == null:
		return

	pending_orders.erase(order)
	active_orders.append(order)

	order.taken_time = Time.get_ticks_msec()
	emit_signal("order_accepted", order)
	print("GameSystem: Order #", id, " accepted")


func complete_order(order_id : int) -> void:
	for order in active_orders:
		if order.order_id == order_id:
			active_orders.erase(order)
			emit_signal("order_completed", order_id)
			print("GameSystem: Order #", order_id, " completed")
			return


func get_pending_order(id : int) -> OrderData:
	for order in pending_orders:
		if order.order_id == id:
			return order
	return null


func start_game() -> void:
	game_started = true


func _process(delta : float) -> void:
	if get_tree().paused == true:
		return
	
	if not game_started:
		return
	
	match GameState:
		GameStates.Orders:
			spaceship_integrity -= INTEGRITY_LOSS_RATE * delta
		GameStates.Cutting:
			spaceship_integrity -= INTEGRITY_LOSS_RATE * delta
		GameStates.Cooking:
			spaceship_integrity -= INTEGRITY_LOSS_RATE * delta
		GameStates.Finalizing:
			spaceship_integrity -= INTEGRITY_LOSS_RATE * delta
		GameStates.Runner:
			spaceship_integrity -= INTEGRITY_LOSS_RATE * delta * 0.4
	
	if spaceship_integrity <= 0:
		game_over()
		spaceship_integrity = 9999999

func game_over():
	spaceship_integrity = MAX_SPACESHIP_INTEGRITY
	pending_orders.clear()
	active_orders.clear()
	for i in occupied_slots:
		occupied_slots[i] = -1
	PantryInventory.inventory.clear()
	SceneLoader.load_scene("res://02_scenes/04_screens/screen_gameOver.tscn", SceneLoader.Transition.NONE, false)
