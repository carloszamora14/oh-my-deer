class_name HumanController
extends PlayerController


func _physics_process(_delta):
	var movement_input = Input.get_action_strength("right") - Input.get_action_strength("left")

	if Input.is_action_just_pressed("jump") and actor.can_jump:
		jump_command.execute(actor)
	elif Input.is_action_pressed("interact") and actor.can_eat:
		eat_command.execute(actor)
	movement_command.execute(actor, MovementCommand.Params.new(movement_input))
