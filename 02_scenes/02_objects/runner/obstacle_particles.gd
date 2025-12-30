extends GPUParticles2D

@onready var debris_particles: GPUParticles2D = $debris_particles
var obstacle_texture : Texture2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	debris_particles.texture = obstacle_texture
