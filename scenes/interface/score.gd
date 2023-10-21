extends Control

@onready var label: Label = $NinePatchRect/Label

func _ready():
	Globals.connect("stats_change", update_stats)
	update_stats()


func update_stats():
	label.text = "Score: " + str(Globals.male_deer_score)
