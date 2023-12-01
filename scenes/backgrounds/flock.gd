extends Node2D

@export_range(-80.0, 24) var db_sound: float = 18.0
var direction: Vector2 = Vector2(-1.0, 0)

func _ready():
	$AudioStreamPlayer2D.volume_db = db_sound
	var flock = $Crows.get_children()
	for crow in flock:
		crow.direction = direction
		crow.speed = 50 + randi() % 15
		crow.fly(randf_range(0.4, 0.8))


func _physics_process(_delta):
	var flock = $Crows.get_children()
	var pos_sum = Vector2(0, 0)
	for crow in flock:
		pos_sum += crow.position
		
	$AudioStreamPlayer2D.position = pos_sum / flock.size()
