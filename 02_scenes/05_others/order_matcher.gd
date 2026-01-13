extends Object
class_name OrderMatcher



#TODO TODO TODO TODO TODO TODO MAKE IT MORE THOUROUGH LATER IF TIME CONSTRAINTS ALLOW

static func match_order_simple(given : OrderData, expected: OrderData) -> int:
	
	if given.bocata_ingredients == expected.bocata_ingredients and given.drink_ingredients == expected.drink_ingredients:
		return 100
	
	if given.bocata_ingredients == expected.bocata_ingredients:
		return 50
		
	if given.drink_ingredients == expected.drink_ingredients:
		return 50
	
	return 0
