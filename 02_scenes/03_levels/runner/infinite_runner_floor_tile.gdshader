shader_type canvas_item;

uniform float scroll_speed = 200.0; // pixels per second
uniform float tile_size = 256.0;    // tile width
uniform float tile_count = 3.0;     // number of tiles in spritesheet

// Simple deterministic hash
float hash(float x) {
	return fract(sin(x * 12.9898) * 43758.5453);
}

void fragment() {
	// Convert UV to pixel coordinates
	vec2 texSize = vec2(1.0) / TEXTURE_PIXEL_SIZE; // texture size in pixels
	vec2 pixel_uv = UV * texSize;

	// Scroll left
	pixel_uv.x += TIME * scroll_speed;

	// Determine the virtual tile index
	float tile_index = floor(pixel_uv.x / tile_size);

	// Random tile selection per tile_index
	float random_tile = floor(hash(tile_index) * tile_count);

	// Local X inside the tile
	float local_x = mod(pixel_uv.x, tile_size);

	// Compute final UV for sampling
	vec2 final_uv;
	final_uv.x = (random_tile * tile_size + local_x) / texSize.x;
	final_uv.y = pixel_uv.y / texSize.y;

	COLOR = texture(TEXTURE, final_uv);
}
