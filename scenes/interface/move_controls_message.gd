extends Message


func _ready():
	animate()


func animate():
	$AnimationPlayer.play("press")
