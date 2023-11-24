extends Node2D

var player_on_top: bool = false
var sounds = ["res://sounds/bridge/metal-creak.mp3", "res://sounds/bridge/Squeaking Metal.mp3"]
var reproducing: bool = false
var first_time: bool = true

func _process(_delta):
	if player_on_top && randf() > 0.9 && !reproducing:
		reproducing = true
		var audio = AudioStreamPlayer2D.new()
		audio.stream = load(sounds.pick_random())
		add_child(audio)
		audio.play()
		await audio.finished
		reproducing = false
		audio.queue_free()


func _on_area_2d_body_entered(_body):
	if first_time:
		first_time = false
		await get_tree().create_timer(1.0, false).timeout
		collapse()
	player_on_top = true


func _on_area_2d_body_exited(_body):
	player_on_top = false


func collapse():
	$AnimationPlayer.play("collapse")


func reset():
	$AnimationPlayer.play("RESET")
	player_on_top = false
	reproducing = false
	first_time = true
