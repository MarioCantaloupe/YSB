extends Object
class_name OrderPrinter


static func build_text(order_data : OrderData) -> String:
	var lines : Array[String] = []

	lines.append("[outline_size=5]Bocata[/outline_size]")

	for item_state in order_data.bocata_ingredients:
		if item_state == null:
			continue
		if item_state.data == null:
			continue

		lines.append(
			format_item_line(
				item_state.data.name,
				item_state.cook_level,
				item_state.chop_level
			)
		)

	lines.append("")
	lines.append("[outline_size=5]Bebida[/outline_size]")

	for item_state in order_data.drink_ingredients:
		if item_state == null:
			continue
		if item_state.data == null:
			continue

		var cook := render_level("*", item_state.cook_level)
		lines.append("[left]%s[right]%s[/right][/left]" % [item_state.data.name, cook])

	return "\n".join(lines)


static func render_level(symbol: String, level: int, max_level: int = 2) -> String:
	var result := ""
	for i in range(max_level):
		if i < level:
			result += "[color=000000][outline_size=5]%s[/outline_size][/color]" % symbol
		else:
			result += "[color=676767]%s[/color]" % symbol
	return result


static func format_item_line(item_name: String, cook_level: int, chop_level: int) -> String:
	var cook := render_level("*", cook_level)
	var chop := render_level("/", chop_level)
	return "[left]%s[right]%s %s[/right][/left]" % [item_name, cook, chop]
