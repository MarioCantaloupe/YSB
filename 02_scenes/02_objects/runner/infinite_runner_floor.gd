extends Node2D

@export var scroll_speed : float = 300.0

@export var floor_textures := [
	{ "texture": preload("res://01_assets/01_sprites/03_environments/Suelo_simple.png"), "weight": 60 },
	{ "texture": preload("res://01_assets/01_sprites/03_environments/Suelo_interseccion.png"), "weight": 30 },
	{ "texture": preload("res://01_assets/01_sprites/03_environments/Suelo_union.png"), "weight": 10 },
]

@export var tiling_width : float = 3000.0


var rng := RandomNumberGenerator.new()
var tile_width : float

func _ready():
	rng.randomize()

	var sample_sprite := get_child(0) as Sprite2D
	tile_width = sample_sprite.get_rect().size.x

	var tiles_needed := int(ceil(tiling_width / tile_width)) + 1

	ensure_tile_count(tiles_needed)
	layout_tiles()


func _process(delta):
	for sprite in get_children():
		sprite.position.x -= scroll_speed * delta

		# If sprite goes off-screen to the left
		if sprite.position.x <= -tile_width:
			move_sprite_to_end(sprite)

func move_sprite_to_end(sprite: Sprite2D):
	var rightmost_x := get_rightmost_x()
	sprite.position.x = rightmost_x + tile_width
	sprite.texture = pick_texture()

func get_rightmost_x() -> float:
	var max_x := -INF
	for s in get_children():
		max_x = max(max_x, s.position.x)
	return max_x

func get_rightmost_edge() -> float:
	var max_x := -INF
	for s in get_children():
		var rect = s.get_global_rect()
		max_x = max(max_x, rect.position.x + rect.size.x)
	return max_x


func pick_texture() -> Texture2D:
	var total_weight := 0
	for f in floor_textures:
		total_weight += f.weight

	var roll := rng.randi_range(0, total_weight - 1)
	var cumulative := 0

	for f in floor_textures:
		cumulative += f.weight
		if roll < cumulative:
			return f.texture

	return floor_textures[0].texture

func ensure_tile_count(count: int):
	while get_child_count() < count:
		var new_sprite := get_child(0).duplicate() as Sprite2D
		add_child(new_sprite)

func layout_tiles():
	var x := 0.0
	for sprite in get_children():
		sprite.texture = pick_texture()
		sprite.position.x = x
		x += tile_width
