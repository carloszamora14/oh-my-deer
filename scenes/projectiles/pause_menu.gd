extends Control

signal continue_game()
signal exit_game()


func _on_continue_pressed():
	continue_game.emit()


func _on_exit_pressed():
	exit_game.emit()
