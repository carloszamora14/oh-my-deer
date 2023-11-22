extends Node
class_name State

signal transitioned(state: State, new_state_name: StringName)

@export var actor: CharacterBody2D
@export var animation_player: AnimationPlayer

func enter() -> void:
	pass


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass
