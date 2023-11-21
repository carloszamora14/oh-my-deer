extends MainLevel

@onready var collision_polygon_2d: CollisionPolygon2D = $StaticBody2D/CollisionPolygon2D
@onready var polygon_2d: Polygon2D = $StaticBody2D/CollisionPolygon2D/Polygon2D

var cutscene_played: bool = false

func _ready():
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		enemy.connect("hunter_shot_bullet", _on_hunter_bullet)
	polygon_2d.polygon = collision_polygon_2d.polygon
	Vector2(40, 140)


func _on_firefly_sound_timeout():
	if randf() > 0.75:
		$AudioStreamPlayer.play()
		await $AudioStreamPlayer.finished
	$FireflySound.start()


func _on_cutscene_area_body_entered(_body):
	if !cutscene_played:
		$AnimationPlayer.play("cutscene")
		cutscene_played = true


func kill_wolf():
	$Hunter.target = $Wolf/Headshot
	$Hunter.shoot_rifle()
