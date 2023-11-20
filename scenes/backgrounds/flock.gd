extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var flock = $Crows.get_children()
	for crow in flock:
		crow.speed = 50 + randi() % 15
		crow.fly(randf_range(0.4, 0.8))


func _physics_process(_delta):
	var flock = $Crows.get_children()
	var pos_sum = Vector2(0, 0)
	for crow in flock:
		pos_sum += crow.position
		
	$AudioStreamPlayer2D.position = pos_sum / flock.size()
