extends MainLevel


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.connect("falling", reset_bridges)


func reset_bridges():
	await get_tree().create_timer(4.0, false).timeout
	for bridge in $BeamBridges.get_children():
		bridge.reset()
