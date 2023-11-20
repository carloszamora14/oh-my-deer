extends MainLevel

@onready var collision_polygon_2d: CollisionPolygon2D = $StaticBody2D/CollisionPolygon2D
@onready var polygon_2d: Polygon2D = $StaticBody2D/CollisionPolygon2D/Polygon2D

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
