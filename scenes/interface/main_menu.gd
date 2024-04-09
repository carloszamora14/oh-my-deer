extends Control


func _on_start_button_pressed():
	reset_globals()
	TransitionLayer.change_scene("res://scenes/levels/parallax.tscn")


func reset_globals():
	Globals.male_deer_health = 100
	Globals.male_deer_lives = 3
	Globals.male_deer_hunger = 5
	Globals.male_deer_position = Vector2(32, 240)
