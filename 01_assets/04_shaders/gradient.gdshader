shader_type canvas_item;

/* =========================
   GRADIENT SETTINGS
   ========================= */
uniform vec4 gradient_bottom : source_color = vec4(0.1, 0.1, 0.2, 1.0);
uniform vec4 gradient_top    : source_color = vec4(0.3, 0.4, 0.8, 1.0);

/* =========================
   TEXTURE SETTINGS
   ========================= */
uniform sampler2D tile_texture;
uniform vec2 tile_scale = vec2(4.0, 4.0); // how many tiles fit on screen
uniform vec4 texture_tint : source_color = vec4(1.0, 1.0, 1.0, 1.0);

/* =========================
   DIAGONAL OFFSET SETTINGS
   ========================= */
uniform float row_offset = 0.5; // horizontal offset for every other row

/* =========================
   SCROLL SETTINGS
   ========================= */
uniform vec2 scroll_direction = vec2(0.1, 0.0);
uniform float scroll_speed = 1.0;

/* =========================
   BLEND MODE
   0 = Multiply
   1 = Overlay
   2 = Add
   ========================= */
uniform int blend_mode = 1;

/* =========================
   BLEND FUNCTIONS
   ========================= */
vec3 blend_overlay(vec3 base, vec3 blend) {
    return mix(
        2.0 * base * blend,
        1.0 - 2.0 * (1.0 - base) * (1.0 - blend),
        step(0.5, base)
    );
}

void fragment() {
    /* -------------------------
       SCREEN UVs
       ------------------------- */
    vec2 uv = SCREEN_UV;

    /* -------------------------
       GRADIENT
       ------------------------- */
    vec4 gradient = mix(gradient_bottom, gradient_top, uv.y);

    /* -------------------------
       TILE UV CALCULATION
       ------------------------- */
    vec2 tiled_uv = uv * tile_scale;

    // Offset every other row
    float row = floor(tiled_uv.y);
    tiled_uv.x += mod(row, 2.0) * row_offset;

    // Scroll animation
    tiled_uv += scroll_direction * TIME * scroll_speed;

    // Wrap UVs
    tiled_uv = fract(tiled_uv);

    /* -------------------------
       SAMPLE TEXTURE
       ------------------------- */
    vec4 tex = texture(tile_texture, tiled_uv) * texture_tint;

    /* -------------------------
       BLEND WITH GRADIENT
       ------------------------- */
    vec3 final_rgb;

    if (blend_mode == 0) {
        final_rgb = gradient.rgb * tex.rgb; // Multiply
    }
    else if (blend_mode == 1) {
        final_rgb = blend_overlay(gradient.rgb, tex.rgb); // Overlay
    }
    else {
        final_rgb = gradient.rgb + tex.rgb; // Add
    }

    COLOR = vec4(final_rgb, gradient.a);
}
