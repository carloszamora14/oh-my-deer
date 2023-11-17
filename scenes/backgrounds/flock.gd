extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var flock = $Crows.get_children()
	for crow in flock:
		crow.speed = 50 + randi() % 15
		crow.fly(randf_range(0.4, 0.8))
