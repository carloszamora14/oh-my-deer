extends CharacterBody2D


const SPEED = 60.0
const JUMP_VELOCITY = -240.0

var moving_left: bool = false
var moving_right: bool = false
var playing_animation: bool = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var blood_particles: PackedScene = preload("res://scenes/player/blood_particles.tscn")


func _ready():
	$AnimationPlayer.play("idle")


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
	var direction = -1 if moving_left else 1 if moving_right else 0
	
	if direction != 0:
		$AnimationPlayer.play("walk")
		velocity.x = direction * SPEED
		$Sprite2D.scale.x = 1 if moving_right else -1
	else:
		if !playing_animation:
			$AnimationPlayer.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func animate():
	moving_left = true
	await get_tree().create_timer(1.0, false).timeout
	moving_left = false
	playing_animation = true
	$AnimationPlayer.play("attack")
	await $AnimationPlayer.animation_finished
	playing_animation = false
	

func hit(_damage, enemy):
	if enemy != null && enemy.is_in_group("Bullet"):
		var bullet_position = enemy.global_position
		var blood = blood_particles.instantiate() as GPUParticles2D
		$Particles.add_child(blood)
		blood.global_position = bullet_position
		await get_tree().create_timer(0.1, false).timeout
		Globals.play_bullet_impact(bullet_position)
		blood.emitting = true
		
		if !playing_animation:
			playing_animation = true
			$AnimationPlayer.play("death")
