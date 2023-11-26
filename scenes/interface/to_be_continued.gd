extends CanvasLayer


func _ready():
	$AnimationPlayer.play("label_transition")


func _process(_delta):
	if Input.is_action_just_pressed("enter"):
		TransitionLayer.change_scene("res://scenes/interface/main_menu.tscn")
