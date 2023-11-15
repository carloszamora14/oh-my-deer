extends CanvasLayer
class_name Message

func _ready():
	animate()


func animate():
	if $AnimationPlayer:
		$AnimationPlayer.play("press")
