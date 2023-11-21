extends CharacterBody2D

signal hunter_shot_bullet(position, direction)
signal display_dialog(lines, timings)

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var can_shoot: bool = true
var sees_deer: bool = false
var is_shooting: bool = false
var health_points: int = 100
var target = null
var angle

var phrases = {
	"coyotes gotta eat": ["res://sounds/hunter/coyotes-gotta-eat.mp3", ["Coyotes gotta eat"], [2.5]],
	"i smoked him": ["res://sounds/hunter/i-smoked-him.mp3", ["I smoked him!"] , [2.1]]
}

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

const sounds: Array[String] = [
	"res://sounds/hunter/this-is-not-a-game-anymore.mp3",
	"res://sounds/hunter/you-will-pay-for-this.mp3",
	"res://sounds/hunter/you-deer-are-going-for-a-ride-in-my-truck.mp3"
]

func _physics_process(delta):
	if target == null:
		var mouse_position = get_global_mouse_position()
	#	var mouse_offset = get_local_mouse_position()
		angle = ((mouse_position - $ShoulderMark.global_position).normalized()).angle()
	else:
		angle = ((target.global_position - $ShoulderMark.global_position).normalized()).angle()
	$Sprites/LeftContainer.rotation = angle
	$Sprites/RightContainer.rotation = angle
	
#	if sees_deer:
#		var angle = (Globals.male_deer_position - global_position).normalized().angle()
#		if angle < 0:
#			angle += 2 * PI
#		if angle >= PI / 4 && angle <= 3 * PI /2:
#			$Sprite2D.scale.x = -0.6
#			$AttackArea.scale.x = -1
#		else:
#			$Sprite2D.scale.x = 0.6
#			$AttackArea.scale.x = 1
#
#		if (can_shoot):
#			is_shooting = true
#			$AnimationPlayer.play("crouch shoot")
#			can_shoot = false
#			$Timer.start()
#			await $AnimationPlayer.animation_finished
#			if !sees_deer:
#				$AnimationPlayer.play("RESET")
#			is_shooting = false
##		if angle > PI/2 and angle 
#	look_at(Globals.male_deer_position)
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	
	# Handle Jump.
	if Input.is_action_just_pressed("interact"):
		shoot_rifle()
#
#	# Get the input direction and handle the movement/deceleration.
#	# As good practice, you should replace UI actions with custom gameplay actions.
#	var direction = Input.get_axis("left", "right")
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


func shoot_rifle():
	$AnimationPlayer.play("shoot")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("RESET")
	
func emit_bullet():
	var gun_nozzle_position = $Sprites/RightContainer/Rifle/GunNozzle.global_position
	var bullet_direction
	if target != null:
		bullet_direction = (target.global_position - $ShoulderMark.global_position).normalized()
	else:
		var mouse_position = get_global_mouse_position()
		bullet_direction = (mouse_position - $ShoulderMark.global_position).normalized()
	hunter_shot_bullet.emit(gun_nozzle_position, bullet_direction)


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

func coyotes_gotta_eat():
	var sound = AudioStreamPlayer2D.new()
	sound.stream = load(phrases["coyotes gotta eat"][0])
	sound.global_position = global_position
	add_child(sound)
	emit_display_dialog("coyotes gotta eat")
	sound.play()
	await sound.finished
	sound.queue_free()


func smoked_him():
	var sound = AudioStreamPlayer2D.new()
	sound.stream = load(phrases["i smoked him"][0])
	sound.global_position = global_position
	add_child(sound)
	emit_display_dialog("i smoked him")
	sound.play()
	await sound.finished
	sound.queue_free()


func emit_display_dialog(phrase):
	var lines = phrases[phrase][1]
	var timings = phrases[phrase][2]
	display_dialog.emit(lines, timings)
