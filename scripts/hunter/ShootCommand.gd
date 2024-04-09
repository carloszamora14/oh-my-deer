class_name ShootCommand
extends Command


func execute(actor: Actor, _data: Object = null) -> void:
	actor.shoot()
