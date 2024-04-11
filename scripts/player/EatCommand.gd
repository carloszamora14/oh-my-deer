class_name EatCommand
extends Command


func execute(actor: Actor, _data: Object = null):
	actor.eat()
