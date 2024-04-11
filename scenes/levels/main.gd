extends Node2D
class_name MainLevel

const WINDOW_HEIGHT := 288
var over := false

var bullet_scene: PackedScene = preload("res://scenes/projectiles/bullet.tscn")
var particle_scene: PackedScene = preload("res://scenes/weapons/trail_particle.tscn")
var blood_particles: PackedScene = preload("res://scenes/player/blood_particles.tscn")
var damage_indicator_scene: PackedScene = preload("res://scenes/interface/damage_indicator.tscn")


func _ready() -> void:
	#$Deer.respawn_coords = Vector2(20, 220)
	Globals.is_player_falling = false
	for player in get_tree().get_nodes_in_group("Player"):
		player.show_damage_indicator.connect(_on_show_damage_indicator)
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		enemy.hunter_shot_bullet.connect(_on_hunter_bullet)
	
	get_tree().node_added.connect(handle_new_node)
	#else:
		#$Deer.position = Vector2(34, 200)


func handle_new_node(node: Node) -> void:
	if node.is_in_group("Bullet"):
		node.emit_blood_particles.connect(handle_blood_particles)


func handle_blood_particles(pos: Vector2) -> void:
	var blood = blood_particles.instantiate() as GPUParticles2D
	var particles_container = get_tree().get_current_scene().get_node("Particles")
	
	particles_container.add_child(blood)
	blood.global_position = pos
	await get_tree().create_timer(0.1, false).timeout
	Globals.play_bullet_impact(pos)
	blood.emitting = true


func _on_show_damage_indicator(pos: Vector2, damage: int) -> void:
	var indicator = damage_indicator_scene.instantiate() as Node2D
	indicator.text = "-" + str(damage)
	indicator.global_position = pos
	add_child(indicator)


func _on_hunter_bullet(bullet_position: Vector2, bullet_direction: Vector2, damage: int, group: String) -> void:
	var bullet = bullet_scene.instantiate() as Area2D
	bullet.init(bullet_position, bullet_direction, group)
	bullet.rotate(bullet_direction.angle())
	bullet.damage = damage
	$Projectiles.add_child(bullet)
	bullet.emit_particle.connect(_on_bullet_emit_particle)


func _on_bullet_emit_particle(pos, dir, vel, p_scale) -> void:
	var particle = particle_scene.instantiate() as Area2D
	particle.init(pos, dir, vel, p_scale)
	$TrailParticles.add_child(particle)


func _on_deer_game_over() -> void:
	over = true
	$CanvasLayer.show()


func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("esc") or Input.is_action_just_pressed("pause")) and not over:
		get_tree().paused = true
		$CanvasLayer2.show()
	#if Globals.male_deer_vulnerable && Globals.male_deer_position.y > WINDOW_HEIGHT * 1.4 && !Globals.male_deer_falling:
		#Globals.male_deer_falling = true
		#$Deer.hit(1000)
		#$Deer.respawn()


func _on_pause_menu_exit_game() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/interface/main_menu.tscn")
#	get_tree().change_scene_to_packed(menu_scene)


func _on_pause_menu_continue_game() -> void:
	get_tree().paused = false
	$CanvasLayer2.hide()
