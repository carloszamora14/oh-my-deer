class_name JumpCommand
extends Command


func execute(actor: Actor, _data: Object = null):
	actor.jump()
