extends CharacterBody2D

const BASE_SPEED = 90.0
var direction: Vector2 = Vector2(-1.0, 0)
var limit_x: float = -200.0
var speed


func _ready():
	$AnimationPlayer.play("fly")
	$Sprite2D.scale.x = (-1 if direction.x < 0 else 1) * abs($Sprite2D.scale.x)
	scale = scale * randf_range(0.9, 1.2)
	speed = BASE_SPEED * randf_range(0.9, 1.2)


func _physics_process(delta):
	if limit_x > position.x:
		queue_free()
	position += direction * speed * delta
	
