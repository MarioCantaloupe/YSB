extends Node2D

# -------------------------------------------------
# Parallax references
# -------------------------------------------------
@onready var parallax_stars_01: Parallax2D = $ParallaxStars01
@onready var parallax_stars_02: Parallax2D = $ParallaxStars02
@onready var parallax_aurora: Parallax2D = $ParallaxAurora

# -------------------------------------------------
# Textures
# -------------------------------------------------
@export var black_hole: Texture2D
@export var planet01: Texture2D
@export var planet02: Texture2D
@export var sun: Texture2D

# -------------------------------------------------
# Parallax speeds
# -------------------------------------------------
@export var stars01_scrollspeed := 20.0
@export var stars02_scrollspeed := 40.0
@export var aurora_scrollspeed := 10.0

# -------------------------------------------------
# Spawn timing
# -------------------------------------------------
@export_group("Spawn Settings")
@export var spawn_interval_min := 2.0
@export var spawn_interval_max := 6.0

@export var min_height_ratio := 0.1
@export var max_height_ratio := 0.9

# -------------------------------------------------
# Spawn weights
# -------------------------------------------------
@export_group("Spawn Weights")
@export var weight_planet01 := 5.0
@export var weight_planet02 := 5.0
@export var weight_sun := 1.0
@export var weight_black_hole := 0.25

# -------------------------------------------------
# Scale / speed / darkness correlation
# -------------------------------------------------
@export_group("Object Correlation")
@export var min_scale := 0.25
@export var max_scale := 1.2

@export var min_speed := 30.0
@export var max_speed := 140.0

@export var min_darkness := 0.35
@export var max_darkness := 1.0

# -------------------------------------------------
# Planet color variation
# -------------------------------------------------
@export_group("Planet Color Variation")
@export var planet_hue_variation := 0.08
@export var planet_saturation_min := 0.6
@export var planet_saturation_max := 1.2
@export var planet_value_min := 0.8
@export var planet_value_max := 1.1

# -------------------------------------------------
# Lighting
# -------------------------------------------------
@export_group("Lighting")
@export var sun_light_texture: Texture2D
@export var planet_light_texture: Texture2D

@export var sun_light_energy := 1.4
@export var planet_light_energy := 0.6

@export var sun_light_radius := 800.0
@export var planet_light_radius := 350.0

# -------------------------------------------------
# Internal
# -------------------------------------------------
var _spawn_timer: Timer
var _active_objects: Array[Sprite2D] = []

# -------------------------------------------------
# Ready
# -------------------------------------------------
func _ready() -> void:
	randomize()

	parallax_stars_01.autoscroll.x = -stars01_scrollspeed
	parallax_stars_02.autoscroll.x = -stars02_scrollspeed
	parallax_aurora.autoscroll.x = -aurora_scrollspeed

	_spawn_timer = Timer.new()
	_spawn_timer.one_shot = true
	_spawn_timer.timeout.connect(_spawn_object)
	add_child(_spawn_timer)

	_schedule_next_spawn()

# -------------------------------------------------
# Spawn scheduling
# -------------------------------------------------
func _schedule_next_spawn() -> void:
	_spawn_timer.wait_time = randf_range(spawn_interval_min, spawn_interval_max)
	_spawn_timer.start()

# -------------------------------------------------
# Spawning
# -------------------------------------------------
func _spawn_object() -> void:
	var sprite := Sprite2D.new()

	var entry := _pick_weighted_entry()
	sprite.texture = entry.texture
	sprite.set_meta("type", entry.type)

	var viewport := get_viewport_rect().size

	sprite.position = Vector2(
		viewport.x + 200.0,
		randf_range(viewport.y * min_height_ratio, viewport.y * max_height_ratio)
	)

	# -----------------------------
	# Scale → speed correlation
	# -----------------------------
	var scale_factor := randf_range(min_scale, max_scale)
	sprite.scale = Vector2.ONE * scale_factor

	var t := inverse_lerp(min_scale, max_scale, scale_factor)
	sprite.set_meta("speed", lerp(min_speed, max_speed, t))

	# -----------------------------
	# Brightness handling
	# -----------------------------
	var brightness : float = lerp(min_darkness, max_darkness, t)

	match entry.type:
		"sun":
			# Suns are always bright
			sprite.self_modulate = Color.WHITE

		"planet":
			sprite.self_modulate = _random_planet_color(brightness)

		"black_hole":
			sprite.self_modulate = Color(
				brightness * 0.6,
				brightness * 0.6,
				brightness * 0.6,
				1.0
			)

		_:
			sprite.self_modulate = Color(brightness, brightness, brightness, 1.0)


	add_child(sprite)
	_active_objects.append(sprite)

	_schedule_next_spawn()

# -------------------------------------------------
# Per-frame movement
# -------------------------------------------------
func _process(delta: float) -> void:
	for sprite in _active_objects.duplicate():
		sprite.position.x -= sprite.get_meta("speed") * delta

		if sprite.position.x < -200.0:
			_active_objects.erase(sprite)
			sprite.queue_free()

# -------------------------------------------------
# Helpers
# -------------------------------------------------
func _pick_weighted_entry() -> Dictionary:
	var pool := []

	if weight_planet01 > 0:
		pool.append({ "texture": planet01, "weight": weight_planet01, "type": "planet" })
	if weight_planet02 > 0:
		pool.append({ "texture": planet02, "weight": weight_planet02, "type": "planet" })
	if weight_sun > 0:
		pool.append({ "texture": sun, "weight": weight_sun, "type": "sun" })
	if weight_black_hole > 0:
		pool.append({ "texture": black_hole, "weight": weight_black_hole, "type": "black_hole" })

	var total := 0.0
	for e in pool:
		total += e.weight

	var roll := randf() * total
	var acc := 0.0

	for e in pool:
		acc += e.weight
		if roll <= acc:
			return e

	return pool[0]

func _random_planet_color(brightness: float) -> Color:
	var hue := randf_range(-planet_hue_variation, planet_hue_variation)
	var sat := randf_range(planet_saturation_min, planet_saturation_max)
	var val := randf_range(planet_value_min, planet_value_max) * brightness

	return Color.from_hsv(fmod(1.0 + hue, 1.0), sat, val, 1.0)
