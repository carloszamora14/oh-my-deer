extends CanvasLayer

var pressed: bool = false

func _ready():
	$AnimationPlayer.play("label_transition")


func _process(_delta):
	if !pressed && Input.is_anything_pressed():
		pressed = true
		TransitionLayer.change_scene("res://scenes/interface/main_menu.tscn")
