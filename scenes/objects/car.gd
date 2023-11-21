extends StaticBody2D

signal display_dialog(lines, timings)
var already_emitted: bool = false


func _on_activation_area_body_entered(body):
	if !already_emitted && body.is_in_group("Player"):
		already_emitted = true
		$AnimationPlayer.play("radio")


func emit_display_dialog():
	var lines = [
			"Good morning, ladies and gentlemen!",
			"It's that time of the year again when nature calls and the",
			"thrill of the hunt beckons. Get ready to embrace the great",
			"outdoors as we kick off the deer hunting season!",
			"Grab your gear, load up, and let the adventure begin.",
	]
	var timings = [1.6, 2.6, 3.0, 2.8, 2.5]
	display_dialog.emit(lines, timings)
