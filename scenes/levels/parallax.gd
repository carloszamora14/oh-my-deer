extends MainLevel

@onready var player: CharacterBody2D = $Deer

var flock_scene: PackedScene = preload("res://scenes/backgrounds/flock.tscn")
var triggered_exit := false

func _on_exit_area_body_entered(_body: Node) -> void:
	player.set_controller(InitialLevelCutsceneController.new(player))
	$AnimationPlayer.play("cutscene")
	spawn_flock(Vector2(1600, 140), Vector2(-1.0, -0.25))


func spawn_flock(pos: Vector2, dir: Vector2) -> void:
	var flock = flock_scene.instantiate() as Node2D
	flock.position = pos
	flock.direction = dir.normalized()
	add_child(flock)


func _on_transition_area_body_entered(_body: Node) -> void:
	TransitionLayer.change_scene("res://scenes/levels/lake.tscn")
