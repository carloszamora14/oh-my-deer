extends HBoxContainer

@onready var health_bar: TextureProgressBar = $TextureProgressBar

func _ready() -> void:
	Globals.stats_change.connect(update_stats)
	update_stats()


func update_stats() -> void:
	health_bar.value = Globals.player_health
	$HBoxContainer/NinePatchRect/Label.text = str(Globals.player_health) + "/100"
	
	var lives_label_text = str(Globals.player_lives) + " Lives"
	if (Globals.player_lives == 1):
		lives_label_text = str(Globals.player_lives) + " Life"
	elif (Globals.player_lives == 0):
		lives_label_text = "Dead"

	$HBoxContainer/LivesContainer/LivesLabel.text = lives_label_text
