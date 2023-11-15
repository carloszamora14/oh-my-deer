extends CharacterBody2D


func _ready():
	$AnimationPlayer.play("idle")


func _process(_delta):
	if randf() >= 0.999:
		$AnimationPlayer.play("caw")
		await $AnimationPlayer.animation_finished
		$AnimationPlayer.play("idle")
