extends Area2D

func emit_shot(damage: int) -> void:
	get_parent().take_damage(damage)
