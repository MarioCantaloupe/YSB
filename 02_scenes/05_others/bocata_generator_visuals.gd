extends Node2D

@onready var bocataGen_logic: Node = $bocataGenerator_logic
@export var item_scene : PackedScene

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_key"):
		display_bocata()

func display_bocata():
	for item in get_tree().get_nodes_in_group("grabbables"):
		item.queue_free()
	
	var item_pos : Vector2 = Vector2(640, 600)
	bocataGen_logic.build_bocata()
	for ingredient_state in bocataGen_logic.bocata_ingredients:
		var new_ingredient = item_scene.instantiate()
		get_tree().current_scene.add_child(new_ingredient)
		#get_tree().current_scene.get_node("WorldItems").add_ch]ild(new_ingredient) #this code should hapen if the scene is correct
		new_ingredient.set_gravity(false)
		new_ingredient.shadow.visible = false
		new_ingredient.collision.disabled = true
		new_ingredient.apply_item_state(ingredient_state)
		new_ingredient.position = item_pos
		item_pos += Vector2(0, -50)
		
