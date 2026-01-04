shader_type canvas_item;

uniform int grid_size : hint_range(10, 1000, 1) = 200;
uniform float dot_scale : hint_range(0.0, 0.5, 0.001) = 0.15;
uniform float brightness_mult : hint_range(0.0, 2.0, 0.1) = 1.0;

uniform vec4 dot_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 bg_color  : source_color = vec4(1.0, 1.0, 1.0, 1.0);

uniform float scroll_speed_x = 0.0;
uniform float scroll_speed_y = 0.0;

void fragment() {
    // -------- SAMPLE THE *ACTUAL* TEXTURE --------
    vec4 tex = texture(TEXTURE, UV);
    float brightness = tex.r; // works perfectly for gradients

    // Aspect correction for circular dots
    vec2 aspect = vec2(1.0, TEXTURE_PIXEL_SIZE.x / TEXTURE_PIXEL_SIZE.y);

    // Scrolling grid (dots move, texture does not)
    vec2 grid_uv = (UV + vec2(scroll_speed_x, scroll_speed_y) * TIME)
                   * float(grid_size) * aspect;

    vec2 cell = fract(grid_uv) - 0.5;
    float dist = length(cell);

    // -------- BRIGHTNESS → DOT RADIUS --------
    float radius = (1.0 - brightness * brightness_mult) * dot_scale;

    // Anti-aliased circle
    float edge = fwidth(dist);
    float mask = smoothstep(radius + edge, radius - edge, dist);

    // Color mix
    vec4 color = mix(bg_color, dot_color, mask);

    // Preserve texture alpha
    color.a *= tex.a;

    COLOR = color;
}
