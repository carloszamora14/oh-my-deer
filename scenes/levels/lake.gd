extends MainLevel

var animation_started: bool = false

func _ready():
	Globals.male_deer_vulnerable = true
	Globals.male_deer_falling = false	
	Globals.reducing_life_instantaneously = false
	$Deer.respawn_active = false
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		enemy.connect("hunter_shot_bullet", _on_hunter_bullet)
	Globals.connect("male_deer_death", reset_scene)


func reset_scene():
	$Hunter.inactive = true
	
	if !$Deer.player_lost:
		TransitionLayer.change_scene("res://scenes/levels/lake.tscn")
		await get_tree().create_timer(1.35, false).timeout
		Globals.update_male_deer_health(100, null)
		Globals.male_deer_hunger = 5
		Globals.male_deer_lives -= 1
	else:
		Globals.male_deer_lives -= 1


func reset_bridges():
	await get_tree().create_timer(4.0, false).timeout
	for bridge in $BeamBridges.get_children():
		bridge.reset()


func _on_exit_area_body_entered(body):
	$Deer.avoid_bullets()
	$Hunter.inactive = true
	if "exit_scene" in body:
		body.exit_scene("res://scenes/levels/before_cliff.tscn")


func _on_start_area_body_entered(_body):
	if !animation_started:
		animation_started = true
		$AnimationPlayer.play("begin_level")


func begin_level_deer():
	$Deer.can_control_character = false
	await get_tree().create_timer(4, false).timeout
	$Deer.can_control_character = true


func begin_level_hunter():
	var target = $Deer/ProjectilesCollision/Collision/Markers.get_children().pick_random()
	$Hunter.start_chasing_deer(target)


func offset_camera():
	var tween = get_tree().create_tween()
	var offset_x = -Globals.male_deer_position.x + 110.0
	tween.tween_property($Deer/Camera2D, "offset:x", offset_x, 0.5)
	tween.set_ease(Tween.EASE_IN_OUT)
	$Deer/Camera2D.limit_right -= offset_x


func _on_shooting_area_body_entered(body):
	if "is_in_shooting_area" in body:
		body.is_in_shooting_area = true


func _on_shooting_area_body_exited(body):
	if "is_in_shooting_area" in body:
		body.is_in_shooting_area = false
