extends CharacterBody2D

var direction: Vector2 = Vector2.RIGHT
var speed: int = 0


func _ready():
	$AnimationPlayer.play("idle")


func _process(delta):
#	if randf() >= 0.999:
#		$AnimationPlayer.play("caw")
#		await $AnimationPlayer.animation_finished
#		$AnimationPlayer.play("idle")
	position += direction * speed * delta


func fly(custom_speed):
	$AnimationPlayer.play("fly", -1, custom_speed)
