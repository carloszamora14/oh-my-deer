extends State

const SPEED = 100.0
const JUMP_VELOCITY = -240.0
const FRICTION = 300;

@export var sprite: Sprite2D
@export var collision_shape: CollisionPolygon2D

func enter():
	animation_player.play("walk")

func physics_update(_delta):
	var direction
	if actor.can_control_character:
		var is_jump_just_pressed: bool = Input.is_action_just_pressed("jump")
		
		if is_jump_just_pressed:
			if actor.is_on_floor():
				actor.velocity.y = JUMP_VELOCITY
		
		direction = Input.get_axis("left", "right")
		
	if direction:
		actor.velocity.x = SPEED * direction
		sprite.scale.x = -1 if direction < 0 else 1
		collision_shape.scale.x = 1 if direction >= 0 else -1
	else:
		transitioned.emit(self, "IdleState")
