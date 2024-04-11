extends Node2D

var second_forest_scene: PackedScene = preload("res://scenes/levels/second_forest.tscn")

func _on_area_2d_body_entered(_body):
	get_tree().change_scene_to_packed(second_forest_scene)
