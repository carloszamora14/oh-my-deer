extends Node2D

@export var shift_hue: float = 0
var is_deer_close: bool = false
var being_eaten: bool = false
var was_eaten: bool = false

var audio_playing: bool = false
var audio: AudioStreamPlayer2D

func _ready():
	var stages = $Sprites.get_children()
	for stage in stages:
		stage.material.set_shader_parameter("shift_hue", shift_hue)
	$AnimationPlayer.animation_finished.connect(deer_ate_grass)
	$AnimationPlayer2.play("RESET")

func _process(_delta):
	if was_eaten:
		return
		
	if being_eaten && Input.is_action_just_released("interact"):
		being_eaten = false
		audio.stop()
		audio_playing = false
		$AnimationPlayer2.play("button")
		$AnimationPlayer.play_backwards("being_eaten")
	if is_deer_close && Input.is_action_just_pressed("interact"):
		$AnimationPlayer.play("being_eaten")
		$AnimationPlayer2.play("RESET")
		
		if !audio_playing: 
			audio_playing = true
			being_eaten = true
			audio = AudioStreamPlayer2D.new()
			audio.stream = load("res://sounds/deer-eating-grass.mp3")
			audio.volume_db = -15
			add_child(audio)
			audio.play(30.4196)
			await audio.finished
			audio.queue_free()


func deer_ate_grass(_name):
	if being_eaten:
		was_eaten = true
		Globals.male_deer_hunger += 1


func _on_active_area_area_entered(_area):
	if !was_eaten:
		is_deer_close = true
		$AnimationPlayer2.play("button")


func _on_active_area_area_exited(_area):
	if !was_eaten:
		is_deer_close = false
		$AnimationPlayer2.play("RESET")
