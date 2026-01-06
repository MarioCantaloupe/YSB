extends Node2D


@onready var knife_tutorial: AnimatedSprite2D = $knife_tutorial
@onready var sprite: Sprite2D = $"../sprite" #used in Item.tscn

signal chop_up(new_level: int)
signal knife_timeout()

@export var slices_per_level : int = 5
@export var chop_audio : AudioStream
@export var min_chop_mouse_speed : float = 1500
@export var max_time_between_slices : float = 1.0

@export var food_particles_scene : PackedScene
var slice_count : int = 0
var chop_level : int = 0

var has_shown_tutorial : bool = false

var slicing_mode : bool = false
var slicing_timer : Timer

func _ready() -> void:
	slicing_timer = Timer.new()
	add_child(slicing_timer)
	slicing_timer.wait_time = max_time_between_slices
	slicing_timer.one_shot = true
	slicing_timer.timeout.connect(slicing_timer_finished)
	


	

func chop_level_up():
	chop_level += 1
	emit_signal("chop_up", chop_level)
	slice_count = 0
	has_shown_tutorial = true
#Mouse over activation
func _on_activation_zone_mouse_entered() -> void:
	var mouse_vel : Vector2 = PlayerCursor.get_avg_mouse_velocity()
	if not PlayerCursor.is_knife or not slicing_mode:
		return
	
	if mouse_vel.length() <= min_chop_mouse_speed:
		return
	
	increase_slice_level()
	
	var particles = food_particles_scene.instantiate() as GPUParticles2D
	add_child(particles)
	
	particles.scale = Vector2(0.5,0.5)
	
	var particle_material : ParticleProcessMaterial = particles.process_material.duplicate() as ParticleProcessMaterial
	particles.process_material = particle_material
	particles.texture = sprite.texture
	
	var max_particle_velocity : float = mouse_vel.length() * 0.6
	var min_particle_velocity : float = max_particle_velocity * 0.4
	
	particle_material.direction = Vector3(
		mouse_vel.normalized().x,
		mouse_vel.normalized().y, 0)
	particle_material.set_param_min(
		ParticleProcessMaterial.PARAM_INITIAL_LINEAR_VELOCITY,
		min_particle_velocity)
	particle_material.set_param_max(
		ParticleProcessMaterial.PARAM_INITIAL_LINEAR_VELOCITY,
		max_particle_velocity)
	particles.emitting = true
	
	particles.finished.connect(particles.queue_free)
	
	if PlayerCursor.is_knife and not has_shown_tutorial:
		knife_tutorial.show()
		


func _input(event: InputEvent) -> void:
	
	if not PlayerCursor.is_knife:
		return
	
	if event.is_action_pressed("Lclick"):
		slicing_mode = true
		print_debug("slicing_mode = " + str(slicing_mode))
		if not has_shown_tutorial:
			knife_tutorial.show()
	if event.is_action_released("Lclick"):
		slicing_mode = false
		print_debug("slicing_mode = " + str(slicing_mode))
		slice_count = 0
		knife_tutorial.hide()

func increase_slice_level():
	slicing_timer.start()
	slice_count += 1
	AudioManager.play_oneshot(chop_audio, 0, 1 + (float(slice_count) / slices_per_level)*0.5, 0, AudioManager.Bus.SFX)
	if slice_count >= slices_per_level:
		chop_level_up()
		knife_tutorial.hide()

func slicing_timer_finished():
	slice_count = 0
	print_debug("knife reset")
	emit_signal("knife_timeout")
