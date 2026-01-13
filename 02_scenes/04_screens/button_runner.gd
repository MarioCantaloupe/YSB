extends SceneChanger

@onready var pantry: Control = %pantry
var final_anim_pos : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	
	match GameSystem.runner_button_shown:
		false:
			hide()
			_recursive_child_connect(pantry)
			final_anim_pos = global_position.x - size.x
		true:
			show()
			global_position.x = global_position.x - size.x
	

func _show_runner_button( _ingredient : ItemData ):
	print("get that fuckin bag grandma")
	show()
	GameSystem.runner_button_shown = true
	var tween_in : Tween = create_tween()
	tween_in.tween_property(self, "global_position:x", final_anim_pos, 0.5
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _recursive_child_connect(root : Node):
	for child in root.get_children():
		if child is PantrySlot:
			child.out_of_ingredients.connect(_show_runner_button)
		_recursive_child_connect(child)
