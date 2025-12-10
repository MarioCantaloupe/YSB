extends RigidBody2D

const REST_RADIUS: float = 80.0   # maximum distance to snap into a rest zone
const LERP_SPEED_SELECTED := 25.0
const LERP_SPEED_REST := 10.0
signal item_grabbed(bool)

@export var food_data : Resource
@export var gravity : bool = true

@onready var sprite: Sprite2D = $sprite
@onready var ice_sprite: Sprite2D = $sprite/ice_sprite
@onready var collision: CollisionShape2D = $collision
@onready var chopping_component: Node2D = $chopping_component
@onready var item_label: Label = $tooltip/item_label
@onready var animation_player: AnimationPlayer = $tooltip/AnimationPlayer
@onready var cook_timer: Timer = $ProgressBar/cook_timer
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var static_dust_particles: GPUParticles2D = $sprite/static_dust

#@onready var click_area: Button = $click_area
@onready var click_area: Area2D = $click_area
@onready var poof_vfx: AnimatedSprite2D = $poof_vfx

@onready var debug_text: Label = $debug_text

# cooking variables
var chop_level : int = 0 : set = _set_chop_level
var cook_level : int = 0 : set = _set_cook_level
@export var is_clean : bool = false
@export var is_frozen : bool = false

# navigation variables
var selected = false : set = _set_selected
var has_reached_rest = false
var rest_point
var rest_nodes = []
var last_item_pos : Vector2

# fake floor variables
@export var enable_fake_floor := true
@export var min_drop_distance := 70.0   # min distance item will fall
@export var max_drop_distance := 140.0  # max distance item will fall (if tossed hard)

var fake_floor_y: float = 0.0
var has_fake_floor := false
var floor_reached := false
var distance_to_fake_floor : float

func _ready() -> void:
	#if not gravity:
		#gravity_scale = 0
	sprite.texture = food_data.sprite_grid[0][0]
	lock_rotation = true
	check_rest_zones()
	if is_frozen:
		ice_sprite.show()
	else:
		ice_sprite.hide()
	item_label.hide()
	progress_bar.hide()
	if not is_clean:
		static_dust_particles.show()
	else:
		static_dust_particles.hide()


#--------------------------------   INPUT   -----------------------------------
#LClick On
func _on_click_area_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if Input.is_action_just_pressed("Lclick"):
		if not PlayerCursor.is_knife:
			#if PlayerCursor.held_item != null and PlayerCursor.held_item != self: # no regrab
				#return
			PlayerCursor.held_item = self
			last_item_pos = get_global_mouse_position()
			print(PlayerCursor.held_item.food_data.name)
			_set_selected(true)
			#PlayerCursor.set_cursor(PlayerCursor.CursorType.HOLDING)
			stop_right_there()
			
			progress_bar.hide()
			emit_signal("item_grabbed", true)

#LClick Off
func _input(event):
	if not PlayerCursor.is_knife:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			#if PlayerCursor.held_item:	
				#PlayerCursor.set_cursor(PlayerCursor.CursorType.CAN_INTERACT)
			_set_selected(false)
			emit_signal("item_grabbed", false)
			
			var shortest_distance = REST_RADIUS
			var closest_rest = null
			
			for child in rest_nodes:
				var distance = global_position.distance_to(child.global_position)
				if distance < shortest_distance:
					shortest_distance = distance
					closest_rest = child
			
			if closest_rest and not closest_rest.is_occupied:
				has_reached_rest = true
				closest_rest.select(self)
				#-------------------we are cooking-----------------------
				station_action(closest_rest.get_parent().action) #gets the station action
				rest_point = closest_rest.global_position
			else:
				has_reached_rest = false
				progress_bar.hide()

#--------------------------------   TICK   ---------------------------------
func _physics_process(delta: float) -> void:
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), LERP_SPEED_SELECTED * delta)
		#look_at(get_global_mouse_position())
	else:
		if has_reached_rest:
			stop_right_there()
			global_position = lerp(global_position, rest_point, LERP_SPEED_REST * delta)
			rotation = lerp_angle(rotation, 0, 10 * delta)
		else:
			freeze = false
	
	debug_text.text = "rested: " + str(has_reached_rest)
	
	# sprite stretching
	if selected == false:
		var v := linear_velocity
		sprite.scale.y = lerp(sprite.scale.y, remap(abs(v.y), 0, 700, .25, 0.35), delta * 20)
		sprite.scale.x = lerp(sprite.scale.x, remap(abs(v.x), 0, 700, .25, 0.35), delta * 10)
	else:
		sprite.scale = lerp(sprite.scale, Vector2(0.35,0.35), delta * 5)
	
	# fake floor
	if enable_fake_floor and has_fake_floor and not selected:
		if global_position.y >= fake_floor_y:
			global_position.y = fake_floor_y
			
			if not floor_reached:
				linear_velocity.y = 0 #stop item immediately
				floor_reached = true
			gravity_scale = 0

			linear_velocity.y = lerp(linear_velocity.y, 0.0, delta * 8.0)
			linear_velocity.x = lerp(linear_velocity.x, 0.0, delta * 6.0)
		else:
			gravity_scale = 1 #return gravity to normal
	if has_fake_floor and not selected:
		distance_to_fake_floor = fake_floor_y - global_position.y
	else:
		distance_to_fake_floor = 0.0
	#print("fake floor: " + str(has_fake_floor) + "distance: " + str(distance_to_fake_floor))

#func _process(_delta: float) -> void:
	#click_area.visible = not PlayerCursor.is_knife
# MAIN ACTIONS
func cook():
	if has_reached_rest:
		if not is_frozen:
			if is_clean:
				cook_timer.start()
				progress_bar.show()
				progress_bar.start_loop()
				print("started timer")
			else:
				show_text("Requiere limpiar")
		else:
			show_text("Requiere descongelar")

func _on_cook_timer_timeout() -> void:
	if has_reached_rest and food_data.cookable:
		cook_level += 1
		print("cook level " + str(cook_level))
		if cook_level < 2:
			play_poof(Color(1.0, 1.0, 1.0, 1.0))
			cook_timer.start()
			progress_bar.start_loop()
		else:
			play_poof(Color(0.0, 0.0, 0.0, 1.0))
			progress_bar.hide()
	else:
		print(str(food_data.name) + " has not reached rest")

func clean():
	if is_frozen:
		show_text("Requiere descongelar")
	else:
		if not is_clean and food_data.cleanable:
			set_sprite(0,0)
			is_clean = true
			static_dust_particles.hide()

func defrost():
	if is_frozen:
		is_frozen = false
		ice_sprite.hide()

# UTILITIES
func station_action(action):
	if action == 0:
		pass
	elif action == 1:
		cook()
	elif action == 2:
		clean()
	elif action == 3:
		defrost()

func get_sprite(x: int, y: int):
	var spritesheet = food_data.sprite_grid
	if x < 0 or x >= 3 or y < 0 or y >= 3:
		push_error("Coordenadas fuera de rango: (%d, %d)" % [x,y])
		return null
	return spritesheet[x][y]

func set_sprite(x: int, y: int):
	var spritesheet = food_data.sprite_grid
	if x < 0 or x >= 3 or y < 0 or y >= 3:
		push_error("Coordenadas fuera de rango: (%d, %d)" % [x,y])
		return
	
	sprite.texture = spritesheet[x][y] 

func show_text(text : String):
	#TODO placeholder
	item_label.text = text
	item_label.show()
	animation_player.play("show_text_tip")

func stop_right_there():
	freeze = true
	linear_velocity = Vector2(0,0)

func check_rest_zones():
	rest_nodes = get_tree().get_nodes_in_group("rest_zone")
	if rest_nodes.is_empty():
		rest_point = global_position
		has_reached_rest = false
		cook_timer.paused = true

func clear_from_station():
	rest_point = Vector2(0,0)

# SETTERS
func _set_chop_level(value):
	chop_level = clamp(value, 0 ,2)
	set_sprite(chop_level, cook_level)
	print(chop_level)
	
func _set_cook_level(value):
	cook_level = clamp(value, 0 ,2)
	set_sprite(chop_level, cook_level)

func _set_selected(value : bool):
	if value == true:
		var zones = get_tree().get_nodes_in_group("rest_zone")
		for i in zones:
			if i.held_item == self:
				i.deselect()
	
	if selected and not value:
		await GlobalScript.wait(.01)
		PlayerCursor.held_item = null
		linear_velocity += PlayerCursor.get_avg_mouse_velocity()
		
		create_fake_floor()
		
	selected = value

# SIGNALED
func _on_chopping_component_knife_slip() -> void:
	pass
	#TODO

func _on_chopping_component_chop_up(_new_level: int) -> void:
	if not is_frozen:
		if is_clean:
			if food_data.cuttable:
				_set_chop_level(chop_level+1)
				print(chop_level)
			else:
				show_text("No cortable")
		else:
			show_text("Requiere limpiar")
	else:
		show_text("Requiere descongelar")

func play_poof(color):
	poof_vfx.self_modulate = color
	poof_vfx.show()
	poof_vfx.play("poof")
	poof_vfx.animation_finished.connect(func(): poof_vfx.hide(), CONNECT_ONE_SHOT)

func create_fake_floor():
	if enable_fake_floor:
			var drop_dist: float = clamp(abs(linear_velocity.y) * 0.2,min_drop_distance,max_drop_distance)
			fake_floor_y = global_position.y + drop_dist
			has_fake_floor = true
			floor_reached = false
