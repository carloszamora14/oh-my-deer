extends CanvasLayer


func _ready():
	for dialog_emitter in get_tree().get_nodes_in_group("DialogEmitter"):
		dialog_emitter.connect("display_dialog", _on_display_dialog)

func _on_display_dialog(lines, timings):
	$DialogBox.run(lines, timings)
	$DialogBox.show()
