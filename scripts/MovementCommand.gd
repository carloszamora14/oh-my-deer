class_name MovementCommand
extends Command


class Params:
	var input: float

	func _init(in_input: float) -> void:
		self.input = in_input


func execute(actor: Actor, data: Object = null) -> void:
	if data is Params:
		actor.move(data.input)
