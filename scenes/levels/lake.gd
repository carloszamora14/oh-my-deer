extends MainLevel


@onready var hunter: CharacterBody2D = $Hunter
@onready var deer: CharacterBody2D = $Deer

var animation_started := false
var pigeon_scene: PackedScene = preload("res://scenes/enemies/pigeon.tscn")


func _ready() -> void:
	super()
	hunter.set_controller(ChasingController.new(hunter))
	#deer.respawn_coords = Vector2(20, 220)
	#deer.respawn_active = false
	#for player in get_tree().get_nodes_in_group("Player"):
		#player.connect("show_damage_indicator", _on_show_damage_indicator)
	#for enemy in get_tree().get_nodes_in_group("Enemy"):
		#enemy.connect("hunter_shot_bullet", _on_hunter_bullet)
	Globals.death.connect(reset_scene)
	
	await get_tree().create_timer(8 * randf(), false).timeout
	spawn_pigeon()


func spawn_pigeon() -> void:
	var pigeon = pigeon_scene.instantiate() as CharacterBody2D
	pigeon.position = Vector2(randf_range(1743.0, 1800.0), randf_range(60.0, 140.0))
	add_child(pigeon)
	await get_tree().create_timer(5.0 + 8 * randf(), false).timeout
	spawn_pigeon()


func reset_scene() -> void:
	if Globals.male_deer_falling:
		hunter.deer_fall()
	else:
		hunter.deer_died()
	
	if !deer.player_lost:
		await get_tree().create_timer(1.5, false).timeout
		TransitionLayer.change_scene("res://scenes/levels/lake.tscn")
		await get_tree().create_timer(1.35, false).timeout
		Globals.update_male_deer_health(100)
		Globals.male_deer_hunger = 5
		Globals.male_deer_lives -= 1
	else:
		Globals.male_deer_lives -= 1


func _on_exit_area_body_entered(body: Node) -> void:
	hunter.threaten()
	deer.avoid_bullets()
	hunter.inactive = true
	await get_tree().create_timer(0.5, false).timeout
	if "exit_scene" in body:
		body.exit_scene("res://scenes/levels/before_cliff.tscn")


func _on_start_area_body_entered(body: Node) -> void:
	if not animation_started and body is Player:
		animation_started = true
		deer.set_controller(LakeStartCutsceneController.new(deer))
		$AnimationPlayer.play("begin_level")


func begin_level_hunter():
	hunter.set_prey(deer)
	hunter.set_controller(ChasingController.new(hunter))


func offset_camera():
	var tween = get_tree().create_tween()
	var offset_x = -Globals.player_position.x + 110.0
	tween.tween_property($Deer/Camera2D, "offset:x", offset_x, 0.5)
	tween.set_ease(Tween.EASE_IN_OUT)
	$Deer/Camera2D.limit_right -= offset_x


func _on_shooting_area_body_entered(body: Node) -> void:
	if body is Hunter:
		body.set_controller(ShootingAreaController.new(body))


func _on_shooting_area_body_exited(body: Node) -> void:
	if body is Hunter:
		body.set_controller(ChasingController.new(body))
