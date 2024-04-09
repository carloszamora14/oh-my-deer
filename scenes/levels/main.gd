extends Node2D
class_name MainLevel

const WINDOW_HEIGHT: int = 288
var over: bool = false

var bullet_scene: PackedScene = preload('res://scenes/projectiles/bullet.tscn')
var particle_scene: PackedScene = preload('res://scenes/weapons/trail_particle.tscn')
var damage_indicator_scene: PackedScene = preload('res://scenes/interface/damage_indicator.tscn')


func _ready():
	#$Deer.respawn_coords = Vector2(20, 220)
	Globals.male_deer_vulnerable = true
	Globals.male_deer_falling = false	
	Globals.reducing_life_instantaneously = true
	for player in get_tree().get_nodes_in_group("Player"):
		player.connect("show_damage_indicator", _on_show_damage_indicator)
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		enemy.connect("hunter_shot_bullet", _on_hunter_bullet)
	if Globals.game_loaded:
		load_game()
	#else:
		#$Deer.position = Vector2(34, 200)


func _on_show_damage_indicator(pos, damage):
	var indicator = damage_indicator_scene.instantiate() as Node2D
	indicator.text = "-" + str(damage)
	indicator.global_position = pos
	add_child(indicator)


func _on_hunter_bullet(bullet_position, bullet_direction, damage):
	var bullet = bullet_scene.instantiate() as Area2D
	bullet.global_position = bullet_position
	bullet.rotate(bullet_direction.angle())
	bullet.direction = bullet_direction
	bullet.damage = damage
	$Projectiles.add_child(bullet)
	bullet.connect("emit_particle", _on_bullet_emit_particle)


func _on_bullet_emit_particle(pos, dir, vel, p_scale):
	var particle = particle_scene.instantiate() as Area2D
	particle.position = pos
	particle.direction = dir
	particle.speed = vel
	particle.scale = p_scale
	$TrailParticles.add_child(particle)


func _on_deer_game_over():
	over = true
	print('Game over')
	$CanvasLayer.show()


func _process(_delta):
	if (Input.is_action_just_pressed("esc") || Input.is_action_just_pressed("pause")) && !over:
		get_tree().paused = true
		$CanvasLayer2.show()
	if Globals.male_deer_vulnerable && Globals.male_deer_position.y > WINDOW_HEIGHT * 1.4 && !Globals.male_deer_falling:
		Globals.male_deer_falling = true
		$Deer.hit(1000)
		$Deer.respawn()


func _on_pause_menu_exit_game():
	save_game_data()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/interface/main_menu.tscn")
#	get_tree().change_scene_to_packed(menu_scene)


func save_game_data():
	var save_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var nodes = get_tree().get_nodes_in_group("Enemy")
	nodes += get_tree().get_nodes_in_group("Item")
	nodes += get_tree().get_nodes_in_group("Player")

	for node in nodes:
		var json_string = save_node(node)
		if json_string:
			# Store the save dictionary as a new line in the save file.
			save_game.store_line(json_string)


func save_node(node):
	if node.scene_file_path.is_empty():
		print("persistent node '%s' is not an instanced scene, skipped" % node.name)
		return null

		# Check the node has a save function.
	if !node.has_method("save"):
		print("persistent node '%s' is missing a save() function, skipped" % node.name)
		return null

	# Call the node's save function.
	var node_data = node.call("save")

	# JSON provides a static method to serialized JSON string.
	var json_string = JSON.stringify(node_data)
	
	return json_string


func _on_pause_menu_continue_game():
	get_tree().paused = false
	$CanvasLayer2.hide()
	

func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var nodes = get_tree().get_nodes_in_group("Enemy")
	nodes += get_tree().get_nodes_in_group("Item")
	for i in nodes:
		i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_game = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()

		# Creates the helper class to interact with JSON
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object
		var node_data = json.get_data()

		# Now we set the remaining variables.
		if "player" in node_data.keys():
			Globals.male_deer_health = node_data["current_health"]
			Globals.male_deer_score = node_data["score"]
			Globals.male_deer_lives = node_data["lives"]
			Globals.male_deer_position = Vector2(node_data["pos_x"], node_data["pos_y"])
			$Deer.position = Vector2(node_data["pos_x"], node_data["pos_y"]) 
		else:
			# Firstly, we need to create the object and add it to the tree and set its position.
			var new_object = load(node_data["filename"]).instantiate()
			get_node(node_data["parent"]).add_child(new_object)
			new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])

			for i in node_data.keys():
				if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
					continue
				new_object.set(i, node_data[i])
