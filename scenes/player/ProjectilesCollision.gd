extends Area2D

func emit_shot(damage, enemy):
	get_parent().hit(damage, enemy)
