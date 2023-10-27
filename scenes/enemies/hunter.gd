extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var can_shoot: bool = true
var sees_deer: bool = false
var is_shooting: bool = false
var health_points: int = 100

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

const sounds: Array[String] = [
	"res://sounds/hunter/this-is-not-a-game-anymore.mp3",
	"res://sounds/hunter/you-will-pay-for-this.mp3",
	"res://sounds/hunter/you-deer-are-going-for-a-ride-in-my-truck.mp3"
]

func _physics_process(delta):
	if sees_deer:
		var angle = (Globals.male_deer_position - global_position).normalized().angle()
		if angle < 0:
			angle += 2 * PI
		if angle >= PI / 4 && angle <= 3 * PI /2:
			$Sprite2D.scale.x = -0.6
			$AttackArea.scale.x = -1
		else:
			$Sprite2D.scale.x = 0.6
			$AttackArea.scale.x = 1
		
		if (can_shoot):
			is_shooting = true
			$AnimationPlayer.play("crouch shoot")
			can_shoot = false
			$Timer.start()
			await $AnimationPlayer.animation_finished
			if !sees_deer:
				$AnimationPlayer.play("RESET")
			is_shooting = false
#		if angle > PI/2 and angle 
#	look_at(Globals.male_deer_position)
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	
	# Handle Jump.
#	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
#		velocity.y = JUMP_VELOCITY
#
#	# Get the input direction and handle the movement/deceleration.
#	# As good practice, you should replace UI actions with custom gameplay actions.
#	var direction = Input.get_axis("ui_left", "ui_right")
#	if direction:
#		velocity.x = direction * SPEED
#	else:
#		velocity.x = move_toward(velocity.x, 0, SPEED)
#
	move_and_slide()
	
func shot_sound():
	var sound = AudioStreamPlayer.new()
	sound.stream = load("res://sounds/hunter/GUNAuto_Shot beretta m12 9 mm (ID 0437)_BSB.mp3")
	add_child(sound)
	sound.play()
	await sound.finished


func _on_timer_timeout():
	can_shoot = true


func _on_notice_area_body_entered(_body):
	sees_deer = true


func _on_notice_area_body_exited(_body):
	if !is_shooting:
		$AnimationPlayer.play("RESET")
	sees_deer = false


func _on_attack_area_body_entered(body):
	if "hit" in body:
		body.hit(50, self)


func hit(damage):
	health_points -= damage
	if (health_points <= 0):
		can_shoot = false
		$Timer.stop()
		queue_free()
	elif randf() >= 0.75:
		var sound = AudioStreamPlayer.new()
		sound.stream = load(sounds.pick_random())
		add_child(sound)
		sound.play()
		await sound.finished

func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
		"current_health" : health_points
	}
	return save_dict
