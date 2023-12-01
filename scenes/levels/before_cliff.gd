extends CanvasLayer


func _ready():
	await get_tree().create_timer(5.0, false).timeout
	TransitionLayer.change_scene("res://scenes/levels/cliff.tscn")
