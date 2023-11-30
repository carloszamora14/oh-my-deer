extends Area2D

signal emit_particle(position, direction, velocity, scale)

@export var speed: int = 120
@export var trail_lifetime: float = 3.4
var direction: Vector2 = Vector2.UP
var initial_pos: Vector2
var max_distance: float = (speed * trail_lifetime)**2
const BASE_DAMAGE: float = 40
var traveled: float
var damage: float


func _ready():
	initial_pos = position


func _physics_process(delta):
	traveled = (position.x - initial_pos.x)**2 + (position.y - initial_pos.y)**2
	
	if (traveled >= 10 * max_distance):
		queue_free()
	
	if (randf() >= traveled / max_distance):
		var particle_position = $TrailMarker.global_position
		var particle_direction = -direction + Vector2.ONE * PI * randf() / 4.0
		var particle_speed = randf() * 2
		var particle_scale = randf_range(0.02, 0.05) * Vector2.ONE 
		emit_particle.emit(particle_position, particle_direction, particle_speed, particle_scale)
	position += direction * speed * delta


func _on_body_entered(body):
	if 'hit' in body && !body.is_in_group("Enemy"):
		if damage <= 0:
			damage = int(BASE_DAMAGE - min(35 * (traveled / (5 * max_distance)), 35))
		body.hit(damage, self)
	queue_free()


func _on_area_entered(area):
	if damage <= 0:
		damage = int(BASE_DAMAGE - min(35 * (traveled / (5 * max_distance)), 35))
	area.emit_shot(damage, self)
	queue_free()
