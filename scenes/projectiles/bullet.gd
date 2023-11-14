extends Area2D

signal emit_particle(position, direction, velocity, scale)

@export var speed: int = 120
@export var trail_lifetime: float = 3.4
var direction: Vector2 = Vector2.UP
var initial_pos: Vector2
var max_distance: float = (speed * trail_lifetime)**2


func _on_ready():
	initial_pos = position


func _process(delta):
	var traveled = (position.x - initial_pos.x)**2 + (position.y - initial_pos.y)**2 
	if (randf() >= traveled / max_distance):
		var particle_position = $TrailMarker.global_position
		var particle_direction = -direction + Vector2.ONE * PI * randf() / 4.0
		var particle_speed = randf() * 2
		var particle_scale = randf_range(0.02, 0.05) * Vector2.ONE 
		emit_particle.emit(particle_position, particle_direction, particle_speed, particle_scale)
#		$GPUParticles2D.emitting = true
	position += direction * speed * delta

#func emit_particle():
#	var particle = particle_scene.instantiate() as Area2D
#	particle.position = $TrailMarker.position
##	particle.direction = -direction + Vector2.ONE * PI * randf() / 4.0
#	particle.speed = randf() * 10
#	$TrailParticles.add_child(particle)

func _on_body_entered(body):
#	if body.has_method('hit'):
#		body.hit()
	if 'hit' in body:
		body.hit()
	queue_free()
