extends Node

var spaceship_integrity
var drinks_unlocked : bool = false
# Array to hold all currently active orders
var active_orders: Array[OrderData] = []

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
