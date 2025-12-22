extends Node
class_name BocataCompare

@export var max_cook_level: int = 2
@export var max_chop_level: int = 2

@export var state_weight: float = 0.6
@export var order_weight: float = 0.4

func compare(
	expected: Array[ItemState],
	actual: Array[ItemState]
) -> Dictionary:
	"""
	Returns:
	{
		"similarity": float (0.0 - 100.0),
		"same_ingredients_different_order": bool
	}
	"""

	if expected.is_empty() and actual.is_empty():
		return {
			"similarity": 100.0,
			"same_ingredients_different_order": false
		}

	var total_score := 0.0
	var max_score := float(expected.size())

	var used_actual_indices: Array[int] = []

	for expected_index in expected.size():
		var expected_state := expected[expected_index]

		var best_match_score := 0.0
		var best_match_index := -1

		for actual_index in actual.size():
			if actual_index in used_actual_indices:
				continue

			var actual_state := actual[actual_index]

			if actual_state.data.id != expected_state.data.id:
				continue

			var state_score := _state_similarity(expected_state, actual_state)
			var order_score := _order_similarity(
				expected_index,
				actual_index,
				expected.size()
			)

			var combined := (
				state_score * state_weight +
				order_score * order_weight
			)

			if combined > best_match_score:
				best_match_score = combined
				best_match_index = actual_index

		if best_match_index != -1:
			used_actual_indices.append(best_match_index)
			total_score += best_match_score

	var similarity_percentage := (total_score / max_score) * 100.0

	var same_ingredients := _same_ingredients(expected, actual)
	var same_order := _same_order(expected, actual)

	return {
		"similarity": clamp(similarity_percentage, 0.0, 100.0),
		"same_ingredients_different_order": same_ingredients and not same_order
	}


func _same_ingredients(a: Array[ItemState], b: Array[ItemState]) -> bool:
	if a.size() != b.size():
		return false

	var ids_a := []
	var ids_b := []

	for s in a:
		ids_a.append(s.data.id)

	for s in b:
		ids_b.append(s.data.id)

	ids_a.sort()
	ids_b.sort()

	return ids_a == ids_b

func _same_order(a: Array[ItemState], b: Array[ItemState]) -> bool:
	if a.size() != b.size():
		return false

	for i in a.size():
		if a[i].data.id != b[i].data.id:
			return false

	return true

func _state_similarity(a: ItemState, b: ItemState) -> float:
	var scores := []

	if a.data.cookable:
		var diff : float = abs(a.cook_level - b.cook_level)
		scores.append(1.0 - float(diff) / max_cook_level)

	if a.data.cuttable:
		var diff : float = abs(a.chop_level - b.chop_level)
		scores.append(1.0 - float(diff) / max_chop_level)

	var clean_score := 0.0
	if a.is_clean == b.is_clean:
		clean_score = 1.0
	scores.append(clean_score)

	var frozen_score := 0.0
	if a.is_frozen == b.is_frozen:
		frozen_score = 1.0
	scores.append(frozen_score)


	var sum := 0.0
	for s in scores:
		sum += s

	return sum / scores.size()

func _order_similarity(expected_index: int, actual_index: int, length: int) -> float:
	var diff : float = abs(expected_index - actual_index)
	return clamp(1.0 - float(diff) / length, 0.0, 1.0)
