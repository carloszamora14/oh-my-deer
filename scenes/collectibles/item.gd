extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("float")


func _on_item_area_body_entered(body):
	$AudioStreamPlayer2D.play()
	call_deferred("hide")
	if "increment_score" in body:
		body.increment_score()
	await $AudioStreamPlayer2D.finished
	call_deferred("queue_free")
