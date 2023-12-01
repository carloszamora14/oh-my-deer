extends MainLevel

var flock_scene: PackedScene = preload("res://scenes/backgrounds/flock.tscn")
var triggered_exit: bool = false

func _on_exit_area_body_entered(_body):
	if !triggered_exit:
		triggered_exit = true
		await get_tree().create_timer(0.25, false).timeout
		$Deer.cutscene_started()
		$AnimationPlayer.play("cutscene")
		spawn_flock(Vector2(1600, 140), Vector2(-1.0, -0.25))


func spawn_flock(pos, dir):
	var flock = flock_scene.instantiate() as Node2D
	flock.position = pos
	flock.direction = dir.normalized()
	add_child(flock)


func change_scene():
	$Deer.walk_right_nonstop()
	


func _on_transition_area_body_entered(_body):
	TransitionLayer.change_scene("res://scenes/levels/lake.tscn")
