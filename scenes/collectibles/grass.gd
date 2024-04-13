extends Node2D

@export var shift_hue: float = 0
@export var sprite_scale: float = 1.0

var is_deer_close := false
var being_eaten := false
var was_eaten : = false

var audio_playing := false
var audio: AudioStreamPlayer2D


func _ready() -> void:
	var stages = $Sprites.get_children()
	for stage in stages:
		stage.scale *= sprite_scale
		stage.material.set_shader_parameter("shift_hue", shift_hue)
	$AnimationPlayer.animation_finished.connect(deer_ate_grass)
	$AnimationPlayer2.play("RESET")

func _process(_delta: float) -> void:
	if was_eaten:
		return
	
	if not is_deer_close:
		$AnimationPlayer2.play("RESET")
	if being_eaten and (Input.is_action_just_released("interact") or not is_deer_close):
		being_eaten = false
		audio.stop()
		audio_playing = false
		$AnimationPlayer2.play("button")
		$AnimationPlayer.play_backwards("being_eaten")
		Globals.stopped_eating.emit()
	if is_deer_close and Input.is_action_just_pressed("interact"):
		$AnimationPlayer.play("being_eaten")
		$AnimationPlayer2.play("RESET")
		
		if not audio_playing: 
			audio_playing = true
			being_eaten = true
			audio = AudioStreamPlayer2D.new()
			audio.stream = load("res://sounds/deer-eating-grass.mp3")
			audio.volume_db = -15
			add_child(audio)
			audio.play(30.4196)
			await audio.finished
			audio.queue_free()


func deer_ate_grass(_name) -> void:
	if being_eaten:
		was_eaten = true
		Globals.player_hunger += 1
		Globals.grass_eaten.emit()


func _on_active_area_area_entered(area: Node) -> void:
	if not was_eaten:
		is_deer_close = true
		if area.has_method("handle_can_eat"):
			area.handle_can_eat(true)
		$AnimationPlayer2.play("button")


func _on_active_area_area_exited(area: Node) -> void:
	if area.has_method("handle_can_eat"):
		area.handle_can_eat(false)
	if not was_eaten:
		is_deer_close = false
		$AnimationPlayer2.play("RESET")
