extends Sprite2D


func fit_texture(sprite: Sprite2D, target_size: Vector2, keep_aspect := false):
	var tex_size = sprite.texture.get_size()
	var sprite_scale = target_size / tex_size

	if keep_aspect:
		scale = Vector2.ONE * min(scale.x, scale.y)

	sprite.scale = sprite_scale
