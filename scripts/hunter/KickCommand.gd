class_name KickCommand
extends Command


func execute(actor: Actor, _data: Object = null):
	actor.kick()
