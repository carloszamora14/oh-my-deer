class_name Hunter
extends Actor


signal hunter_shot_bullet(position, direction, damage)
signal display_dialog(lines, timings)

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const SPEED = 100.0
const JUMP_VELOCITY = -200.0

var prey: Actor
var marker: Marker2D

var can_jump := true
var can_shoot := true
var can_kick := false

var is_shooting := false
var is_kicking := false

var prey_in_notice_area := false
var prey_in_kick_area := false
var prey_in_kick_damage_area := false


func _ready() -> void:
	set_controller(HunterController.new(self))


func _physics_process(delta) -> void:
	if prey != null:
		var prey_pos = marker.global_position
		
		handle_aiming(prey_pos)
		handle_scale(prey_pos)
	
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		can_jump = true

	move_and_slide()


func set_prey(in_prey: Actor) -> void:
	prey = in_prey
	marker = prey.get_damage_indicator()


func handle_scale(prey_pos: Vector2) -> void:
	var dx =  prey_pos.x - global_position.x
	var sign = dx / abs(dx) if dx != 0 else 1

	$Sprites.scale.x = sign * abs($Sprites.scale.x)
	$SpriteRunning.scale.x = sign * abs($SpriteRunning.scale.x)
	$ShoulderMark.scale.x = sign
	$CollisionShape2D.position.x = 7.2 if sign < 0  else 0


func handle_aiming(prey_pos: Vector2) -> void:
	if not is_kicking:
		var angle = ((prey_pos - $ShoulderMark.global_position).normalized()).angle()

		$Sprites/LeftContainer.rotation = (PI - angle) if prey_pos.x < global_position.x else angle
		$Sprites/RightContainer.rotation = (PI - angle) if prey_pos.x < global_position.x else angle


func handle_emit_bullet():
	var gun_nozzle_position = $Sprites/RightContainer/Rifle/GunNozzle.global_position
	var bullet_direction
	if prey == null:
		var mouse_position = get_global_mouse_position()
		bullet_direction = (mouse_position - $ShoulderMark.global_position).normalized()
	else:
		bullet_direction = (marker.global_position - $ShoulderMark.global_position).normalized()
	hunter_shot_bullet.emit(gun_nozzle_position, bullet_direction, 30)


func move(direction: int) -> void:
	if not is_shooting and not is_kicking:
		velocity.x = move_toward(velocity.x, direction * SPEED, SPEED)
		#$AnimationPlayer.play("RESET")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)


func shoot() -> void:
	is_shooting = true
	can_shoot = false
	$Timer.start()

	$AnimationPlayer.play("shoot")
	await $AnimationPlayer.animation_finished
	is_shooting = false
	$AnimationPlayer.play("RESET")


func jump() -> void:
	if is_on_floor() and can_jump:
		can_jump = false
		velocity.y = JUMP_VELOCITY


func _on_notice_area_body_entered(body):
	if body == prey:
		prey_in_notice_area = true


func _on_notice_area_body_exited(body):
	if body == prey:
		prey_in_notice_area = false


func _on_kick_area_body_entered(body):
	if body == prey:
		prey_in_kick_area = true


func _on_kick_area_body_exited(body):
	if body == prey:
		prey_in_kick_area = false


func _on_kick_damage_area_body_entered(body):
	if body == prey:
		prey_in_kick_damage_area = true


func _on_kick_damage_area_body_exited(body):
	if body == prey:
		prey_in_kick_damage_area = false


func _on_timer_timeout():
	can_shoot = true
