extends StaticBody2D

signal playing_radio(text)
var already_emitted: bool = false


func _on_activation_area_body_entered(body):
	if !already_emitted && body.is_in_group("Player"):
		already_emitted = true
		$AnimationPlayer.play("radio")
		
