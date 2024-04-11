class_name LakeStartCutsceneController
extends PlayerController


var player_can_move := true


func _ready() -> void:
	await get_tree().create_timer(0.4, false).timeout
	player_can_move = false
	await get_tree().create_timer(4.0, false).timeout
	actor.set_controller(HumanController.new(actor))


func _physics_process(_delta: float) -> void:
	var movement

	if player_can_move:
		movement = Input.get_action_strength("right") - Input.get_action_strength("left")
	else:
		movement = 0

	movement_command.execute(actor, MovementCommand.Params.new(movement))
