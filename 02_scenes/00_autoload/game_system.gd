extends Node

var total_spaceship_integrity : float = 900
var spaceship_integrity : float = 900 #seconds
var integrity_loss_rate : float = 1 #integrity/seconds
var game_started : bool = false
var drinks_unlocked : bool = false

# GAME TIPS
var game_tip_scene : String = "res://02_scenes/04_screens/game_tip_box.tscn"
var orders_tip_shown : bool = false
var cutting_tip_shown : bool = false
var cooking_tip_shown : bool = false
var blending_tip_shown : bool = false
var stacking_tip_shown : bool = false


# Array to hold all currently active orders
var active_orders: Array[OrderData] = []

func _ready() -> void:
	spaceship_integrity = total_spaceship_integrity

# Called when a new note is clicked
func register_order(id: int, bocata_data: Array[ItemState], drink_data : Array[ItemState]):
	var new_order = OrderData.new()
	new_order.order_id = id
	new_order.sandwich_ingredients = bocata_data
	new_order.creation_time = Time.get_ticks_msec()
	
	new_order.drink_ingredients = drink_data
	
	print("GameSystem: Registered Order #", id, " with ", bocata_data.size(), " ingredients.")
	
	active_orders.append(new_order)


func complete_order(order_id: int):
	for order in active_orders:
		if order.order_id == order_id:
			print("GameSystem: Order #", order_id, " completed!")
			active_orders.erase(order)
			return


func get_order_by_id(order_id: int) -> OrderData:
	for order in active_orders:
		if order.order_id == order_id:
			return order
	return null

func start_game():
	game_started = true

func _process(delta: float) -> void:
	if game_started:
		spaceship_integrity -= integrity_loss_rate * delta
