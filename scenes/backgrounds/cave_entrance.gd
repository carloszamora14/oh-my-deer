extends Node2D

var player_near: bool = false
var cave_scene: PackedScene = preload("res://scenes/levels/cave.tscn")

func _process(_delta):
	if player_near and Input.is_action_pressed("interact"):
		get_tree().change_scene_to_packed(cave_scene)

func _on_area_2d_body_entered(_body):
	player_near = true
	$Label.show()


func _on_area_2d_body_exited(_body):
	player_near = false
	$Label.hide()
