extends Control


func _on_start_button_pressed():
	reset_globals()
	TransitionLayer.change_scene("res://scenes/levels/parallax.tscn")


func reset_globals():
	Globals.player_health = 100
	Globals.player_lives = 3
	Globals.player_hunger = 5
	Globals.player_position = Vector2(32, 240)
