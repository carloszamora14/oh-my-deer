extends CharacterBody2D

signal game_over()
signal player_throw_candy(marker_pos, candy_direction)

const SPEED = 100.0
const JUMP_VELOCITY = -240.0
const FRICTION = 300;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var respawn_coords = Vector2(40, 140)
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player_lost: bool = false
var eating: bool = false
var can_throw_candy: bool = true
var transparent: bool = false
var can_control_character: bool = true
var cutscene_speed: int = 0

var blood_particles: PackedScene = preload("res://scenes/player/blood_particles.tscn")

func _ready():
	Globals.male_deer_position = global_position
	Globals.connect("male_deer_death", respawn)

func _physics_process(delta):
	if player_lost:
		return
	
	Globals.male_deer_position = global_position
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	move_and_slide()


func avoid_bullets():
	$AnimationPlayer.play("deactivate_collision")
	transparent = true


func reset():
	transparent = false
	$AnimationPlayer.play_backwards("deactivate_collision")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("idle")


func hit(damage, enemy):
	if transparent || player_lost:
		return

	if enemy != null && enemy.is_in_group("Bullet"):
		var bullet_position = enemy.global_position
		var blood = blood_particles.instantiate() as GPUParticles2D
		$Particles.add_child(blood)
		blood.global_position = bullet_position
		await get_tree().create_timer(0.1, false).timeout
		Globals.play_bullet_impact(bullet_position)
		blood.emitting = true

	Globals.update_male_deer_health(Globals.male_deer_health - damage, enemy)
	$Sprite2D.material.set_shader_parameter("progress", 0.6)
	Globals.male_deer_vulnerable = false
	if (Globals.male_deer_health > 0):
		var sound = AudioStreamPlayer.new()
		sound.stream = load("res://sounds/deer-scream1.mp3")
		add_child(sound)
		sound.play()
	await get_tree().create_timer(0.3, false).timeout
	Globals.male_deer_vulnerable = true
	$Sprite2D.material.set_shader_parameter("progress", 0)


func increment_score():
	Globals.male_deer_score += 1


func respawn():
	if player_lost:
		return

	can_control_character = false
	Globals.male_deer_vulnerable = false
	$DeathSound.play()
#	get_node("DeerCollision").disabled = true    # disable
	await get_tree().create_timer(0.6).timeout
	can_control_character = true
	Globals.male_deer_vulnerable = true
	get_node("DeerCollision").disabled = false   # enable
	velocity = Vector2.ZERO
	if Globals.male_deer_lives > 0:
		global_position = respawn_coords
		Globals.update_male_deer_health(100, null)
	else:
		player_lost = true
#		get_node("DeerCollision").disabled = true   # enable
		game_over.emit()
		hide()
	Globals.male_deer_falling = false
	


func _on_idle_timer_timeout():
	if randf() > 0.5:
		eating = true
		$AnimationPlayer.play("crouch")
		await $AnimationPlayer.animation_finished
		eating = false


func _on_timer_timeout():
	can_throw_candy = true
	
func save():
	var save_dict = {
		"player": true,
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
		"current_health" : Globals.male_deer_health,
		"lives": Globals.male_deer_lives,
		"score": Globals.male_deer_score
	}
	return save_dict

func cutscene_started():
	can_control_character = false
	

func cutscene_ended():
	can_control_character = true


func cliff_cutscene():
	$DeerCollision.scale.x = -1
	$FloorCollision.scale.x = -1
	$Sprite2D.scale.x = -1
	cutscene_speed = 15
	await get_tree().create_timer(0.3, false).timeout
	cutscene_speed = 0


func cliff_cutscene_2nd_part():
	cutscene_speed = 10
	await get_tree().create_timer(1, false).timeout
	cutscene_speed = 0


func cliff_cutscene_3rd_part():
	$DeerCollision.scale.x = 1
	$FloorCollision.scale.x = 1
	$Sprite2D.scale.x = 1
	await get_tree().create_timer(0.1, false).timeout
	cutscene_speed = 80
	await get_tree().create_timer(2.0, false).timeout
	Globals.male_deer_vulnerable = false
	await get_tree().create_timer(1, false).timeout
	cutscene_speed = 0
	await get_tree().create_timer(0.5, false).timeout
	gravity = 0
