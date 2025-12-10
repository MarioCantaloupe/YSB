extends CharacterBody2D
class_name Player

signal GameEnd

@onready var sprite: Sprite2D = $sprite
@onready var hit_cooldown: Timer = $hit_cooldown

# game logic variables

@export var lung_capacity : float = 60
@onready var lung_bar: ProgressBar = $lung_bar
var can_hit : bool = true

#carrito variables
var carrito_demon : bool = false
@export var carrito_threshold : int = 5
var carrito_level : int = 0

# movement variables
@export var jump_height : float = 300
@export var jump_time_to_peak : float = 0.5
@export var jump_time_to_descent : float = 3

@export var slam_velocity : float = 400

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1
@onready var fall_gravity_buffer : float = fall_gravity

func _ready() -> void:
	lung_bar.max_value = lung_capacity
	lung_bar.value = lung_capacity

func _physics_process(delta: float) -> void:

	# jump
	if is_on_floor():
		if Input.is_action_just_pressed("jump"): 
			jump()
	else:
		velocity.y += get_custom_gravity() * delta # gravity
		
		if Input.is_action_just_released("jump") or is_on_ceiling(): # variable jump
			if velocity.y < 0:
				velocity.y *= 0.5
		
		if Input.is_action_pressed("slam"): # fall fast
			fall_gravity_buffer += slam_velocity
		else:
			fall_gravity_buffer = fall_gravity
	
	var v := velocity
	sprite.scale.y = lerp(sprite.scale.y, remap(abs(v.y), 0, 700, 0.75, 1), delta * 20)
	
	move_and_slide()

func _process(delta: float) -> void:
	lung_capacity -= delta
	lung_bar.value = lung_capacity
	if lung_capacity <= 0:
		no_air_left()

func jump():
	velocity.y = jump_velocity

func get_custom_gravity():
	return jump_gravity if velocity.y < 0.0 else fall_gravity_buffer

func _on_collision_area_entered(area: Area2D) -> void:
	if area.is_in_group("space_obstacle") and can_hit:
		if not carrito_demon:
			lung_capacity -= 5
			can_hit = false
			hit_cooldown.start()
		else:
			pass #player unharmed, play eating animation

func _on_hit_cooldown_timeout() -> void:
	can_hit = true
	print("inv frames ended")

func increase_carrito_level(value):
	carrito_level += value
	print(carrito_level)
	if carrito_level >= carrito_threshold:
		activate_demon_mode()
		#change animation

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("debug_key"):
		activate_demon_mode()

func activate_demon_mode():
	carrito_demon = true
	print("carrito demon ON")
	carrito_level = 0

func no_air_left():
	queue_free()
	emit_signal("GameEnd")
