extends Node2D

@onready var bocataGen_logic: Node = $bocataGenerator_logic
var item_scene : PackedScene = preload("res://02_scenes/02_objects/item/item.tscn")

func display_bocata(): #should be called from outside
	for item in get_tree().get_nodes_in_group("grabbables"):
		item.queue_free()
	
	var item_pos : Vector2 = global_position
	var _bocata_height : int = 0 #measured in pixels
	
	for ingredient_state in bocataGen_logic.bocata_ingredients:
		var new_ingredient = item_scene.instantiate()
		
		if get_tree().current_scene.get_node("WorldItems"):
			get_tree().current_scene.get_node("WorldItems").add_child.call_deferred(new_ingredient) #this code should hapen if the scene is correct
		else:
			get_tree().current_scene.add_child.call_deferred(new_ingredient)
		await new_ingredient.ready
		new_ingredient.set_gravity(false)
		new_ingredient.shadow.visible = false
		new_ingredient.collision.disabled = true
		new_ingredient.apply_item_state(ingredient_state)
		new_ingredient.position = item_pos
		item_pos += Vector2(0, new_ingredient.ingredient_height)
		print("bocata add: " + str(_bocata_height) + "+" + str(new_ingredient.ingredient_height))
		_bocata_height += new_ingredient.ingredient_height
	print("final bocata height: " + str(_bocata_height))
