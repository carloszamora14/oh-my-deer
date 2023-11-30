extends CanvasLayer
class_name Message

var tween: Tween
@export var animation_player: AnimationPlayer

func _ready():
	$Panel.modulate.a = 0
	hide()


func animate():
	if animation_player:
		animation_player.play("press")


func fade_in(time):
	show()
	tween = get_tree().create_tween()
	tween.tween_property($Panel, "modulate:a", 1, time)
	animate()


func fade_out(time):
	var remaining: float = 1.0
	
	if tween && tween.is_running():
		tween.kill()
		remaining = $Panel.modulate.a
		
	tween = get_tree().create_tween()
	tween.tween_property($Panel, "modulate:a", 0, time * remaining)
	await tween.finished
	hide()
