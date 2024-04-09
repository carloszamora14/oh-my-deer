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
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/interface/main_menu.tscn")
#	get_tree().change_scene_to_packed(menu_scene)


func _on_pause_menu_continue_game():
	get_tree().paused = false
	$CanvasLayer2.hide()
