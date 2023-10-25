extends Node2D
class_name MainLevel

const WINDOW_HEIGHT: int = 288

func _on_deer_game_over():
	print('Game over')
	$CanvasLayer.show()


func _process(_delta):
	if Globals.male_deer_position.y > WINDOW_HEIGHT * 1.2 and !Globals.male_deer_falling:
		Globals.male_deer_falling = true
		$Deer.hit(1000, null)
		$Deer.respawn()
