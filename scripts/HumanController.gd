class_name HumanController
extends ActorController


func _physics_process(_delta):
	var movement_input = Input.get_action_strength("right") - Input.get_action_strength("left")

	if Input.is_action_just_pressed("jump"):
		jump_command.execute(actor)
	#else:
	movement_command.execute(actor, MovementCommand.Params.new(movement_input))
