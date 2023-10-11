extends HBoxContainer

@onready var health_bar: TextureProgressBar = $TextureProgressBar

func _ready():
	Globals.connect("stats_change", update_stats)
	update_stats()


func update_stats():
	health_bar.value = Globals.female_deer_health
	$NinePatchRect/Label.text = str(Globals.female_deer_health) + "/100"
	$LivesContainer/LivesLabel.text = str(Globals.female_deer_lives) + " lives"
