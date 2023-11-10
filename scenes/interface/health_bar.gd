extends HBoxContainer

@onready var health_bar: TextureProgressBar = $TextureProgressBar

func _ready():
	Globals.connect("stats_change", update_stats)
	update_stats()


func update_stats():
	health_bar.value = Globals.male_deer_health
	$HBoxContainer/NinePatchRect/Label.text = str(Globals.male_deer_health) + "/100"
	if (Globals.female_deer_lives > 0):
		$HBoxContainer/LivesContainer/LivesLabel.text = str(Globals.male_deer_lives) + " lives"
	else:
		$HBoxContainer/LivesContainer/LivesLabel.text = "Death"
