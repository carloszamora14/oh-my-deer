extends CharacterBody2D


const SPEED = 60.0
const JUMP_VELOCITY = -240.0

var moving_left: bool = false
var moving_right: bool = false
var playing_animation: bool = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


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
	await get_tree().create_timer(1.1, false).timeout
	moving_left = false
	playing_animation = true
	$AnimationPlayer.play("attack")
	await $AnimationPlayer.animation_finished
	playing_animation = false
