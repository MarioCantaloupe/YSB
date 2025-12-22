shader_type canvas_item;

/* ────────────────────────────────────────────────────────
   ──  Parameters (shown in the editor) ────────────────────
   ────────────────────────────────────────────────────────
*/
uniform vec4  colour1      : hint_color;   // First colour
uniform vec4  colour2      : hint_color;   // Second colour

uniform int   gradientType : hint_range(1, 5, 1);   // 1‑5
uniform float proportion   : hint_range(0.0, 10.0, 0.001); // stretch
uniform float noise        : hint_range(0.0, 1.0, 0.01);      // 0‑1

// Alpha clipping – useful for making shapes
uniform bool  clipAlpha    : hint_default(false);
uniform float clipThreshold = 0.5;  // default 0.5

/* ────────────────────────────────────────────────────────
   ──  Helper functions ──────────────────────────────────
   ────────────────────────────────────────────────────────
*/

// Pseudo‑random value – only one line per UV (fast, no sampler)
float random(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453123) * 2.0 - 1.0;
}

// Euclidean distance – radial gradient
float calculate_distance(vec2 a, vec2 b) {
    return length(a - b);
}

// Linear interpolation (clamped)
vec4 lerp_colour(vec4 a, vec4 b, float t) {
    return a + (b - a) * clamp(t, 0.0, 1.0);
}

/* ────────────────────────────────────────────────────────
   ──  Main body – fragment shader ────────────────────────
   ────────────────────────────────────────────────────────
*/
void fragment() {
    // Start with a base ratio – the “stretch” you chose
    float ratio = proportion;

    /* ─────────────────────────────────────────────────────
       ──  Five gradient “modes” ────────────────────────
       ─────────────────────────────────────────────────────
    */
    if (gradientType == 1) {
        // ── 1 – Radial (center → corners)
        ratio = clamp(
                 calculate_distance(UV, vec2(0.5, 0.5))
                 * (proportion * 2.0)
                 + random(UV) * noise,
                 0.0,
                 1.0
               );
    } else if (gradientType == 2) {
        // ── 2 – Horizontal (left → right)
        ratio *= UV.x + random(UV) * noise;
    } else if (gradientType == 3) {
        // ── 3 – Diagonal (top‑left → bottom‑right)
        ratio *= abs(UV.x - UV.y) + random(UV) * noise;
    } else if (gradientType == 4) {
        // ── 4 – Anti‑diagonal (top‑right → bottom‑left)
        ratio *= abs(((UV.x * -1.0) + 1.0) - UV.y) + random(UV) * noise;
    } else {
        // ── 5 – Combined / “All‑corner” ramp
        ratio *= (abs(((UV.x * -1.0) + 1.0) - UV.y)
                  + abs(UV.x - UV.y))
                 + random(UV) * noise;
    }

    // Final colour – mix the two colours according to the ratio
    COLOR = lerp_colour(colour1, colour2, ratio);

    /* ─────────────────────────────────────────────────────
       ──  Alpha clipping (optional) ───────────────────────
       ─────────────────────────────────────────────────────
    */
    if (clipAlpha) {
        if (COLOR.a > clipThreshold) {
            COLOR.a = 1.0;      // opaque
        } else {
            COLOR.a = 0.0;      // fully transparent
        }
    }
}
