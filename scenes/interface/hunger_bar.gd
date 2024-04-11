extends NinePatchRect

var icons: Array

func _ready() -> void:
	Globals.hunger_change.connect(update_hunger_bar)
	icons = $HBoxContainer.get_children()
	update_hunger_bar()


func update_hunger_bar() -> void:
	for index in range(len(icons)):
		icons[index].modulate.a = 0 if Globals.player_hunger <= index else 255
