extends Area2D

func _ready():
	$Sprite2D.play("default")

func _on_body_entered(_body):
	$Sprite2D.play("growing")
