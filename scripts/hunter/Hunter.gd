class_name Hunter
extends Actor


signal hunter_shot_bullet(position, direction, damage, target_group)
signal display_dialog(lines, timings)

@onready var animation_player = $AnimationPlayer

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const SPEED = 100.0
const JUMP_VELOCITY = -200.0

var prey: Actor
var target_group: String

var can_jump := true
var can_shoot := true
var can_kick := true

var is_shooting := false
var is_kicking := false

var prey_in_notice_area := false
var prey_in_kick_area := false
var prey_in_kick_damage_area := false


func _ready() -> void:
	set_controller(HunterController.new(self))


func _physics_process(delta: float) -> void:
	if prey != null:
		var prey_pos = prey.global_position
		
		handle_aiming(prey_pos)
		handle_scale(prey_pos)
	
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		can_jump = true

	move_and_slide()


func set_prey(in_prey: Actor) -> void:
	prey = in_prey


func handle_scale(prey_pos: Vector2) -> void:
	if abs(global_position.x - prey_pos.x) < 40:
		return
#
	var dx =  prey_pos.x - global_position.x
	var dir_sign = dx / abs(dx) if dx != 0 else 1

	$Sprites.scale.x = dir_sign * abs($Sprites.scale.x)
	$SpriteRunning.scale.x = dir_sign * abs($SpriteRunning.scale.x)
	$ShoulderMark.scale.x = dir_sign
	$CollisionShape2D.position.x = 7.2 if dir_sign < 0 else 0.0


func handle_aiming(prey_pos: Vector2) -> void:
	if abs(global_position.x - prey_pos.x) < 20:
		return
	
	if not is_kicking:
		var angle = ((prey_pos - $ShoulderMark.global_position).normalized()).angle()

		$Sprites/LeftContainer.rotation = (PI - angle) if prey_pos.x < global_position.x else angle
		$Sprites/RightContainer.rotation = (PI - angle) if prey_pos.x < global_position.x else angle


func handle_emit_bullet() -> void:
	var gun_nozzle_position = $Sprites/RightContainer/Rifle/GunNozzle.global_position
	var bullet_direction
	if prey == null:
		var mouse_position = get_global_mouse_position()
		bullet_direction = (mouse_position - $ShoulderMark.global_position).normalized()
	else:
		bullet_direction = (prey.global_position - $ShoulderMark.global_position).normalized()
	hunter_shot_bullet.emit(gun_nozzle_position, bullet_direction, 30, target_group)


func move(direction: int) -> void:
	if not is_shooting and not is_kicking:
		velocity.x = move_toward(velocity.x, direction * SPEED, SPEED)
		if direction != 0:
			animation_player.play("run")
		else:
			animation_player.play("RESET")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)


func shoot(_group: String) -> void:
	target_group = _group
	is_shooting = true
	shot_cooldown()

	animation_player.play("shoot")
	await animation_player.animation_finished
	is_shooting = false
	animation_player.play("RESET")


func jump() -> void:
	if is_on_floor() and can_jump:
		can_jump = false
		velocity.y = JUMP_VELOCITY


func kick() -> void:
	is_kicking = true
	kick_cooldown()

	animation_player.play("kick")
	await animation_player.animation_finished
	shot_cooldown()
	is_kicking = false
	animation_player.play("RESET")


func shot_cooldown() -> void:
	can_shoot = false
	$ShotCooldownTimer.start()


func kick_cooldown() -> void:
	can_kick = false
	$KickCooldownTimer.start()


func _on_notice_area_body_entered(body) -> void:
	if body == prey:
		prey_in_notice_area = true


func _on_notice_area_body_exited(body) -> void:
	if body == prey:
		prey_in_notice_area = false


func _on_kick_area_body_entered(body) -> void:
	if body == prey:
		prey_in_kick_area = true


func _on_kick_area_body_exited(body) -> void:
	if body == prey:
		prey_in_kick_area = false


func _on_kick_damage_area_body_entered(body) -> void:
	if body == prey:
		prey_in_kick_damage_area = true


func _on_kick_damage_area_body_exited(body) -> void:
	if body == prey:
		prey_in_kick_damage_area = false


func _on_shot_cooldown_timer_timeout() -> void:
	can_shoot = true


func _on_kick_cooldown_timer_timeout() -> void:
	can_kick = true
