class_name OrderData
extends Resource

@export var order_id: int
@export var bocata_ingredients: Array[ItemState] #  items for bocata
@export var drink_ingredients: Array[ItemState] #  items for drink
@export var creation_time: int # when order was created
@export var taken_time: int = -1 # -1 = “not taken yet”
