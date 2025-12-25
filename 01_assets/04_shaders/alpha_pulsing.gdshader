shader_type canvas_item;

uniform float speed: hint_range(0, 50) = 1.0;
uniform float amplitude: hint_range(0, 1) = 0.5;
uniform float offset: hint_range(-1, 1) = 0.0;
uniform vec4 color: source_color = vec4(1, 1, 1, 1);

void fragment() {
    // Calculate time-based sine wave
    float phase = TIME * speed + UV.x * offset;
    float fade = sin(phase) * amplitude * 0.5 + 0.5; // Normalize to 0-1 range

    // Apply the fade to the texture
    COLOR = texture(TEXTURE, UV) * color * fade;
}
