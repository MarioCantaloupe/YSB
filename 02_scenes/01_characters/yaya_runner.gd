extends CharacterBody2D
class_name Player

signal GameEnd

@onready var sprite_yaya: AnimatedSprite2D = $YayaEntity/sprite_yaya
@onready var sprite_carrito: AnimatedSprite2D = $YayaEntity/sprite_carrito
@onready var hit_cooldown: Timer = $hit_cooldown
@onready var demon_cart_timer: Timer = $demonCart_timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision: Area2D = $YayaEntity/collision
@onready var scaler: Node2D = $YayaEntity


@export var lung_capacity : float = 60
var can_hit : bool = true

var carrito_demon : bool = false
@export var carrito_threshold : int = 5
var carrito_level : int = 0
var ready_to_eat : bool = false
var chew_count : int = 0
var chew_loops : int = 2

@export var jump_height : float = 300
@export var jump_time_to_peak : float = 0.5
@export var jump_time_to_descent : float = 3
@export var slam_velocity : float = 400

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1
@onready var fall_gravity_buffer : float = fall_gravity

func _ready() -> void:
	sprite_carrito.play("idle")
	sprite_carrito.animation_finished.connect(_on_carrito_animation_finished)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("debug_key"):
		set_demon_mode(true)
	
	if Input.is_action_just_pressed("slam") and is_on_floor() :
		duck(true)
	if Input.is_action_just_released("slam"):
		duck(false)

func _process(delta: float) -> void:
	lung_capacity -= delta
	if lung_capacity <= 0:
		no_air_left()
	

func _physics_process(delta: float) -> void:
	if is_on_floor():
		if Input.is_action_just_pressed("jump"): 
			jump()
	else:
		velocity.y += get_custom_gravity() * delta
		
		if Input.is_action_just_released("jump") or is_on_ceiling():
			if velocity.y < 0:
				velocity.y *= 0.5
		
		if Input.is_action_pressed("slam"):
			fall_gravity_buffer += slam_velocity
		else:
			fall_gravity_buffer = fall_gravity
	
	#var v := velocity
	#scaler.scale.y = lerp(scaler.scale.y, remap(abs(v.y), 0, 700, 0.75, 1), delta * 20)
	
	move_and_slide()

func jump():
	velocity.y = jump_velocity

func duck(value : bool):
	if value:
		scaler.scale.y = 0.5
		#var tween : Tween
	else:
		scaler.scale.y = 1

func get_custom_gravity():
	return jump_gravity if velocity.y < 0.0 else fall_gravity_buffer

func yaya_hit():
	lung_capacity -= 5
	can_hit = false
	animation_player.play("yaya_hit")
	hit_cooldown.start()

func increase_carrito_level(value):
	if not carrito_demon:
		carrito_level += value
		print_debug("carrito_level" + str(carrito_level))
		if carrito_level >= carrito_threshold:
			set_demon_mode(true)

func set_demon_mode(value):
	if value == true:
		carrito_demon = true
		demon_form()
		print_debug("carrito demon ON")
		carrito_level = 0
		demon_cart_timer.start()
	if value == false:
		carrito_demon = false
		regular_form()
		print_debug("carrito demon OFF")

func demon_form():
	sprite_carrito.modulate = Color(1.825, 0.168, 1.328, 1.0)

func regular_form():
	sprite_carrito.modulate = Color(1.0, 1.0, 1.0, 1.0)

func no_air_left():
	queue_free()
	emit_signal("GameEnd")

func _on_collision_area_entered(area: Area2D) -> void:
	if area.is_in_group("space_obstacle") and can_hit:
		if not carrito_demon:
			yaya_hit()
		else:
			chew_loops = area.get_parent().obstacle_data.loot_amount
			sprite_carrito.play("mouth_close")

func _on_hit_cooldown_timeout() -> void:
	can_hit = true

func _on_demon_cart_timer_timeout() -> void:
	set_demon_mode(false)

func _on_carrito_animation_finished() -> void:
	match sprite_carrito.animation:
		"mouth_open":
			sprite_carrito.play("mouth_open")  
		"mouth_close":
			chew_count = 0
			sprite_carrito.play("chew")
		"chew":
			chew_count += 1
			if chew_count < chew_loops:
				sprite_carrito.play("chew")
			else:
				sprite_carrito.play("gulp")
		"gulp":
			sprite_carrito.play("idle")
		"idle":
			sprite_carrito.play("idle")

func _on_vision_collision_area_entered(_area: Area2D) -> void:
	if carrito_demon:
		ready_to_eat = true
		sprite_carrito.play("mouth_open")
