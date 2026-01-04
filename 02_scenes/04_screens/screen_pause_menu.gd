extends Control

var options_screen = preload("res://02_scenes/04_screens/screen_options.tscn")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var MainMenu : String = "res://02_scenes/04_screens/screen_mainMenu.tscn"
func _ready() -> void:
	
	visible = false
	animation_player.play("RESET")
	

func _process(_delta: float) -> void:
	testEsc()

func resume():
	animation_player.play_backwards("menu_popup")
	await animation_player.animation_finished
	visible = false
	get_tree().paused = false
	print("cursor scene = "+str(not get_tree().get_root().is_in_group("mouse_scene")))
	if owner.is_in_group("mouse_scene"):
		PlayerCursor.enable_cursor(true)
	else:
		PlayerCursor.enable_cursor(false)
	
func pause():
	get_tree().paused = true
	visible = true
	animation_player.play("menu_popup")
	
func testEsc():
	if Input.is_action_just_pressed("pause"):
		if not get_tree().paused:
			PlayerCursor.enable_cursor(true)
			pause()
			print("game paused")
		elif get_tree().paused:
			resume()
			print("game resumed")


func _on_resume_pressed() -> void:
	resume()


func _on_options_pressed() -> void:
	var options = options_screen.instantiate()
	add_child(options)
	
	options.exited.connect(func():
		options.queue_free()
		visible = true
		PlayerCursor.enable_cursor(true)
	)


func _on_quit_pressed() -> void:
	get_tree().paused = false
	SceneLoader.load_scene(MainMenu, SceneLoader.Transition.FADE, true)
