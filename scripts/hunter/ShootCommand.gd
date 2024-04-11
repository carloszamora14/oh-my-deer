class_name ShootCommand
extends Command

class Params:
	var target_group: String

	func _init(in_group: String) -> void:
		self.target_group = in_group


func execute(actor: Actor, data: Object = null) -> void:
	if data is Params:
		actor.shoot(data.target_group)
