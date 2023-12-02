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
		var is_jump_pressed: bool = Input.is_action_pressed("jump")
		
		if is_jump_pressed && actor.is_on_floor() && actor.can_jump:
			actor.can_jump = false
			actor.velocity.y = JUMP_VELOCITY
		
		direction = Input.get_axis("left", "right")
		
	if direction or actor.cutscene_speed:
		transitioned.emit(self, "WalkingState")
	else:
		actor.velocity.x = move_toward(actor.velocity.x, 0, FRICTION)
