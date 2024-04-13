extends MainLevel

@onready var collision_polygon_2d: CollisionPolygon2D = $StaticBody2D/CollisionPolygon2D
@onready var polygon_2d: Polygon2D = $StaticBody2D/CollisionPolygon2D/Polygon2D

var cutscene_played := false

func _ready() -> void:
	$Deer.respawn_coords = Vector2(20, 220)
	$Hunter.allow_to_aim = true
	super()
	polygon_2d.polygon = collision_polygon_2d.polygon


func _on_firefly_sound_timeout() -> void:
	if randf() > 0.75:
		$AudioStreamPlayer.play()
		await $AudioStreamPlayer.finished
	$FireflySound.start()


func _on_cutscene_area_body_entered(_body: Node) -> void:
	if not cutscene_played:
		$AnimationPlayer.play("cutscene")
		cutscene_played = true


func kill_wolf() -> void:
	$Hunter.target = $Wolf/Headshot
	$Hunter.shoot_rifle(null)


func shoot_deer() -> void:
	$Hunter.target = $Deer/ProjectilesCollision/Collision/Markers.get_children().pick_random()
	$Hunter.shoot_rifle(Globals.male_deer_health - 1)
	await get_tree().create_timer(2, false).timeout
	$Hunter.aiming = false


func fade_to_black():
	TransitionLayer.change_scene("res://scenes/interface/to_be_continued.tscn")


func play_water_splash():
	var sound = AudioStreamPlayer2D.new()
	sound.stream = load("res://sounds/water-splash.mp3")
	sound.max_distance = 10000
	sound.global_position = $Deer.global_position
	add_child(sound)
	sound.play()
	await sound.finished
	sound.queue_free()
