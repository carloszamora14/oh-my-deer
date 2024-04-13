extends Area2D


func handle_can_eat(value: bool) -> void:
	get_parent().can_eat = value
