extends Area2D

@export var speed: int = 200
var direction: Vector2 = Vector2.RIGHT


func _ready():
	$Timer.start()


func _process(delta):
	position += direction * speed * delta


func _on_body_entered(body):
#	if body.has_method('hit'):
#		body.hit()
	if 'hit' in body && "respawn" not in body:
		body.hit(25)
		queue_free()


func _on_timer_timeout():
	queue_free()
