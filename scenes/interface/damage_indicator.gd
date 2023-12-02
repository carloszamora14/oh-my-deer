extends Node2D

var velocity: float = 30
var direction: Vector2 = Vector2.UP
var text: String = "-123"

func _ready():
	$Control/Label.text = text
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0, 1.0)
	tween.set_ease(Tween.EASE_OUT)
	await tween.finished
	queue_free()

func _physics_process(delta):
	position += direction * velocity * delta
