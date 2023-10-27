extends Node2D

var taken: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("float")


func _on_item_area_body_entered(body):
	if !taken:
		taken = true
		$AudioStreamPlayer2D.play()
		hide()
		if "increment_score" in body:
			body.increment_score()
		await $AudioStreamPlayer2D.finished
		queue_free()


func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x,
		"pos_y" : position.y,
	}
	return save_dict
