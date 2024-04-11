class_name ShootingAreaController
extends HunterController


func _physics_process(_delta: float) -> void:
	if actor.prey != null:
		var movement_input = (
			int(actor.global_position.x < actor.prey.global_position.x) -
			int(actor.global_position.x > actor.prey.global_position.x)
		)
		
		if movement_input < 0:
			movement_command.execute(actor, MovementCommand.Params.new(movement_input))
		else:
			movement_command.execute(actor, MovementCommand.Params.new(0))
			if actor.prey_in_kick_area and actor.can_kick and not actor.is_shooting:
				kick_command.execute(actor)
			elif actor.can_shoot and not actor.is_kicking:
				shoot_command.execute(actor)
			
		if actor.is_on_wall() and actor.can_jump and not actor.is_shooting and not actor.is_kicking:
				jump_command.execute(actor)
