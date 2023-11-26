extends NinePatchRect

var icons: Array

func _ready():
	Globals.connect("hunger_change", update_hunger_bar)
	icons = $HBoxContainer.get_children()


func update_hunger_bar():
	for index in range(len(icons)):
		icons[index].modulate.a = 0 if Globals.male_deer_hunger <= index else 255
