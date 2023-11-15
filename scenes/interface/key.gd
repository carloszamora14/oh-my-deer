extends Node2D

@export var texture: Texture

func _ready():
	$Sprite2D.texture = texture
