class_name InitialLevelCutsceneController
extends PlayerController


var _init_time := 0


func _ready() -> void:
	_init_time = Time.get_ticks_msec()


func _physics_process(_delta: float) -> void:
	var current_time = Time.get_ticks_msec() - _init_time

	if current_time < 10000:
		movement_command.execute(actor, MovementCommand.Params.new(0))
	else:
		movement_command.execute(actor, MovementCommand.Params.new(1))
