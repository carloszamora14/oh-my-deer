extends Area2D

var parent_group := "Player"

func emit_shot(damage: int) -> void:
	get_parent().take_damage(damage)
