extends CharacterBody2D


const SPEED = 30.0
const JUMP_VELOCITY = -200.0
const DAMAGE = 100

var initial_pos: Vector2
var is_going_right: bool = true
var can_attack: bool = true
var is_player_near: bool = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player_being_tracked = null

@export var patrol_distance = 60


func _ready():
	$BearSprite.play("run")
	velocity.x = SPEED
	initial_pos = global_position


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if player_being_tracked != null and is_player_near and can_attack:
		var current_target = player_being_tracked
		$BearSound.play()
		can_attack = false;
		$BearSprite.play("attack")
		$AttackCooldown.start()
		await get_tree().create_timer(0.8).timeout
		current_target.hit(DAMAGE, self)
		$BearSprite.play("run")
	if abs(initial_pos.x - position.x) > patrol_distance:
		is_going_right = !is_going_right
		scale.x = -scale.x
	velocity.x = SPEED if is_going_right else -SPEED
		
#	$BearSprite.flip_h = !is_going_right
#	$BearCollision.scale = Vector2(1 if is_going_right else -1, 1)
#	$NoticeArea/CollisionPolygon2D.scale = Vector2(1 if is_going_right else -1, 1)
#	$AttackArea/CollisionShape2D.scale = Vector2(1 if is_going_right else -1, 1)

	move_and_slide()


func _on_attack_cooldown_timeout():
	can_attack = true


#func _on_notice_area_body_entered(body):
#	if player_being_tracked == null:
#		player_being_tracked = body


#func _on_notice_area_body_exited(body):
#	if player_being_tracked == body:
#		player_being_tracked = null
#
#
func _on_attack_area_body_entered(body):
	if player_being_tracked == null:
		player_being_tracked = body
	is_player_near = true


func _on_attack_area_body_exited(body):
	if player_being_tracked == body:
		player_being_tracked = null
	is_player_near = false


func reset_target():
	player_being_tracked = null
	is_player_near = false
