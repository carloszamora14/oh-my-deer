extends State

const JUMP_VELOCITY = -240.0
const FRICTION = 300;

func enter():
	animation_player.play("crouch")
	await animation_player.animation_finished
	animation_player.play("idle")

func physics_update(_delta):
	var direction
	if actor.can_control_character:
		var is_jump_just_pressed: bool = Input.is_action_just_pressed("jump")
		
		if is_jump_just_pressed:
			if actor.is_on_floor():
				actor.velocity.y = JUMP_VELOCITY
		
		direction = Input.get_axis("left", "right")
		
	if direction:
		transitioned.emit(self, "WalkingState")
	else:
		actor.velocity.x = move_toward(actor.velocity.x, 0, FRICTION)
