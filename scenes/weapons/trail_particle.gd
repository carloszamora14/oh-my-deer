extends Area2D

@export var lifetime: float = 2.1

var speed: float = 1.0
var direction = Vector2.ZERO


func init(pos: Vector2, dir := Vector2.ZERO, _speed := 1.0, _scale := Vector2.ONE) -> void:
	position = pos
	direction = dir
	speed = _speed
	scale = _scale


func _ready() -> void:
	await get_tree().create_timer(lifetime, false).timeout
	var tween = get_tree().create_tween()
	var duration = randf_range(0.2, 1.0)
	tween.set_parallel(true)
	tween.tween_property($Sprite2D, "scale", Vector2.ZERO, duration)
	tween.tween_property($Sprite2D, "modulate:a", 0, duration)
	await tween.finished
	queue_free()
#
func _physics_process(delta: float) -> void:
	position += direction * speed * delta
