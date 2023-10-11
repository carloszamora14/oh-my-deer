extends CharacterBody2D


const SPEED = 60.0
const JUMP_VELOCITY = -400.0
const DAMAGE = 20

var initial_pos: Vector2
var is_going_right: bool = true
var can_attack: bool = true
var is_player_near: bool = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player_being_tracked = null

@export var patrol_distance = 50


func _ready():
	initial_pos = global_position


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if player_being_tracked != null and is_player_near and can_attack:
		$FoxSprite.play("attack")
		can_attack = false;
		player_being_tracked.hit(DAMAGE, self)
		$AttackCooldown.start()
	else:
		$FoxSprite.play("run")
	
	if abs(initial_pos.x - position.x) > patrol_distance:
		is_going_right = !is_going_right
		
	$FoxSprite.flip_h = !is_going_right
	$FoxCollision.scale = Vector2(1 if is_going_right else -1, 1)
	$NoticeArea/CollisionPolygon2D.scale = Vector2(1 if is_going_right else -1, 1)
	$AttackArea/CollisionShape2D.scale = Vector2(1 if is_going_right else -1, 1)
	velocity.x = SPEED if is_going_right else -SPEED

	move_and_slide()


func _on_attack_cooldown_timeout():
	can_attack = true


func _on_notice_area_body_entered(body):
	if player_being_tracked == null:
		player_being_tracked = body


func _on_notice_area_body_exited(body):
	if player_being_tracked == body:
		player_being_tracked = null


func _on_attack_area_body_entered(body):
	if player_being_tracked == body:
		is_player_near = true


func _on_attack_area_body_exited(body):
	if player_being_tracked == body:
		is_player_near = false


func reset_target():
	player_being_tracked = null
	is_player_near = false
