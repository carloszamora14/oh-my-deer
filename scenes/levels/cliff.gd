extends MainLevel

@onready var collision_polygon_2d: CollisionPolygon2D = $StaticBody2D/CollisionPolygon2D
@onready var polygon_2d: Polygon2D = $StaticBody2D/CollisionPolygon2D/Polygon2D

func _ready():
	polygon_2d.polygon = collision_polygon_2d.polygon
	Vector2(40, 140)


func _process(_delta):
	pass

func _on_firefly_sound_timeout():
	if randf() > 0.75:
		$AudioStreamPlayer.play()
		await $AudioStreamPlayer.finished
	$FireflySound.start()
