shader_type particles;

float rand(uint s) {
    s ^= s << uint(13);
    s ^= s >> uint(17);
    s ^= s << uint(5);
    return float(s) / 4294967296.0;
}


void start() {
    // Unique seed per particle
    uint seed = RANDOM_SEED + uint(NUMBER);

    // One random value per particle
    float r = rand(seed);

    // Scale correlation
    float scale = mix(0.4, 1.0, r);
    TRANSFORM[0].xy *= scale;
    TRANSFORM[1].xy *= scale;

    // Speed correlation
    VELOCITY *= mix(0.3, 1.0, r);

    // Brightness correlation
    COLOR.rgb *= mix(0.4, 1.2, r);
}
