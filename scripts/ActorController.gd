class_name ActorController
extends Node


var actor: Actor

var movement_command := MovementCommand.new()
var attack_command := AttackCommand.new()
var jump_command := JumpCommand.new()


func _init(in_actor: Actor) -> void:
	self.actor = in_actor
