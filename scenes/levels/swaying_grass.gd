extends Node2D

var tall_grass_scene: PackedScene = load("res://scenes/objects/tall_grass.tscn")


func _ready():
	$Node2D/Deer.gravity = 0
	place_patch(Vector2(50,50), Vector2(1000,1000))


func place_grass(x, y):
	var grass = tall_grass_scene.instantiate() as Area2D
	grass.position = Vector2(x + randf_range(-10.0, 10.0), y + randf_range(-2.0,2.0))
	grass.get_node("Sprite2D").material.set_shader_parameter("offset", float(x * y))
	grass.get_node("Sprite2D").material.set_shader_parameter("shift_hue", 0.83)
	$Node2D.add_child(grass)


func place_patch(from, to):
	for x in range(from.x, to.x, 40):
		for y in range(from.y, to.y, 10):
			place_grass(x, y)
