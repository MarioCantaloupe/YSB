class_name OrderData
extends Resource

@export var order_id: int
@export var sandwich_ingredients: Array[ItemState] # The items for the sandwich
@export var drink_ingredients: Array[ItemState]    # The items for the drink
@export var creation_time: int                     # When was it ordered (ticks or seconds)
