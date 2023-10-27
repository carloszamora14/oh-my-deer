extends Control

#var main_scene: PackedScene = preload('res://scenes/levels/parallax.tscn')

func _ready():
	if FileAccess.file_exists("user://savegame.save"):
		$VBoxContainer/ContinueButton.disabled = false

func _on_start_button_pressed():
#	SceneHandler.change_scene(main_scene)
#	get_tree().change_scene_to_packed(main_scene)
	reset_globals()
	Globals.game_loaded = false
	get_tree().change_scene_to_file("res://scenes/levels/parallax.tscn")


func _on_continue_button_pressed():
	Globals.game_loaded = true
	get_tree().change_scene_to_file("res://scenes/levels/parallax.tscn")


func reset_globals():
	Globals.male_deer_health = 100
	Globals.male_deer_score = 0
	Globals.male_deer_lives = 3
	Globals.male_deer_position = Vector2(32, 240)
