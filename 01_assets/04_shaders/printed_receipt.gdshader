shader_type canvas_item;
render_mode unshaded, blend_mix;


uniform float threshold : hint_range(0.0, 1.0, 0.01) = 0.9;


uniform vec4 paper_color : source_color = vec4(0.95, 0.93, 0.85, 1.0); // Warm paper
uniform vec4 ink_color : source_color = vec4(0.05, 0.05, 0.05, 1.0);   // Dark ink

uniform float dither_scale : hint_range(1.0, 64.0, 1.0) = 4.0;
uniform float dither_strength : hint_range(0.0, 0.5, 0.001) = 0.15;


uniform float grain_amount : hint_range(0.0, 1.0, 0.01) = 0.1; // Dust and paper texture
uniform float scanline_intensity : hint_range(0.0, 1.0, 0.01) = 0.3; // Horizontal print lines
uniform float scanline_frequency : hint_range(1.0, 50.0, 0.5) = 5.0;
uniform float feed_line_intensity : hint_range(0.0, 1.0, 0.01) = 0.4; // Mechanical feed marks
uniform float feed_line_spacing : hint_range(5.0, 100.0, 1.0) = 40.0; // Pixels between feed marks


float rand(vec2 coord) {
    return fract(sin(dot(coord, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    float gray = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));

    vec2 texture_size = 1.0 / TEXTURE_PIXEL_SIZE;

    vec2 pixel_uv = UV * texture_size;
    vec2 noise_uv = floor(pixel_uv / dither_scale);

    float noise = rand(noise_uv) - 0.5;

    float dynamic_threshold = threshold + (noise * dither_strength);
    float is_ink = step(gray, dynamic_threshold);

    float scanline = sin(pixel_uv.y * 0.1 * scanline_frequency);
    is_ink *= (1.0 - abs(scanline) * scanline_intensity);

    float feed = step(1.0 - (feed_line_intensity * 0.1), fract(pixel_uv.y / feed_line_spacing));
    is_ink = mix(is_ink, is_ink * 0.5, feed);

    float grit = rand(pixel_uv) * grain_amount;

    vec3 final_color = mix(paper_color.rgb, ink_color.rgb, is_ink);
    final_color -= grit;

    COLOR = vec4(final_color, tex_color.a);
}