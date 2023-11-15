extends Node2D

@export var shift_hue: float = 0

func _ready():
	var stages = $Sprites.get_children()
	for stage in stages:
		stage.material.set_shader_parameter("shift_hue", shift_hue)
