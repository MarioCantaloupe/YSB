extends Node
class_name ItemSpawner

var item_scene: PackedScene = preload("res://02_scenes/02_objects/item/item.tscn")
@onready var generator: RandomItemGenerator = $random_item_generator # or autoload
#TODO #TODO #TODO
func spawn_random_item(position: Vector2) -> Node:
	# Generate random state using your generator
	var state := generator.generate_random_item_state(generator.get_weights_dict())
	if state == null:
		push_error("Failed to generate ItemState")
		return null

	# Instance the item scene
	var item_instance = item_scene.instantiate()
	item_instance.position = position

	# Apply state
	item_instance.apply_item_state(state)

	# Add to scene
	get_tree().current_scene.add_child(item_instance)

	return item_instance
