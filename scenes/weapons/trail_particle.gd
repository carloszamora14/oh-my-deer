extends Area2D

var speed: float = 1.0
var direction = Vector2.ZERO
@export var lifetime: float = 2.1

func _ready():
	await get_tree().create_timer(lifetime).timeout
	var tween = get_tree().create_tween()
	var duration = randf_range(0.2, 1.0)
	tween.set_parallel(true)
	tween.tween_property($Sprite2D, "scale", Vector2.ZERO, duration)
	tween.tween_property($Sprite2D, "modulate:a", 0, duration)
	await tween.finished
	queue_free()
#
func _physics_process(delta):
	position += direction * speed * delta
