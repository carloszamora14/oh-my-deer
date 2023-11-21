extends CharacterBody2D

signal game_over()
signal player_throw_candy(marker_pos, candy_direction)

const SPEED = 100.0
const JUMP_VELOCITY = -240.0
const FRICTION = 300;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var respawn_coords = Vector2(40, 140)
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var dying: bool = false
var player_lost: bool = false
var eating: bool = false
var can_throw_candy: bool = true
var cutscene_playing: bool = false
var transparent: bool = false

var blood_particles: PackedScene = preload("res://scenes/player/blood_particles.tscn")

func _ready():
	Globals.male_deer_position = global_position
	Globals.connect("male_deer_death", respawn)

func _physics_process(delta):
	if player_lost:
		return
	
	Globals.male_deer_position = global_position
	
	if (!dying):
#		if Input.is_action_just_pressed("interact") and can_throw_candy:
#			var marker_pos = $AnimationPlayer/Marker2D.global_position
##			print(marker_pos, global_position)
#			var candy_direction = Vector2(1, 0) if $AnimationPlayer.scale.x >= 0 else Vector2(-1, 0)
#			# Emit the position
#			player_throw_candy.emit(marker_pos, candy_direction)
#			can_throw_candy = false
#			$Timer.start()
		#elif
		if !cutscene_playing:
			if Input.is_action_just_pressed("jump") and is_on_floor():
	#			$AnimationPlayer.play("death")
				$IdleTimer.stop()
				$IdleTimer.start()
				velocity.y = JUMP_VELOCITY
			var direction = Input.get_axis("left", "right")
#			var directiony = Input.get_axis("up", "down")
#			if directiony:
#				velocity.y = directiony * SPEED
#				if directiony == -1:
#					$AnimationPlayer.play("walk_up")
#				else:
#					$AnimationPlayer.play("walk_down")
#			else:
#				velocity.y = move_toward(velocity.y, 0, FRICTION)
			if direction != 0:
				$IdleTimer.stop()
				$IdleTimer.start()
				if !eating:
					$AnimationPlayer.play("walk")
				$Sprite2D.scale.x = -1 if direction <= 0 else 1
				$DeerCollision.scale = Vector2(1 if direction >= 0 else -1, 1)
				velocity.x = direction * SPEED
			else:
				if !eating:
					$AnimationPlayer.play("idle")
				velocity.x = move_toward(velocity.x, 0, FRICTION)
		else:
			if !eating:
				$AnimationPlayer.play("idle")
			velocity.x = move_toward(velocity.x, 0, FRICTION)
			
		if not is_on_floor():
			velocity.y += gravity * delta

		move_and_slide()


func avoid_bullets():
	$AnimationPlayer.play("deactivate_collision")
	transparent = true


func reset():
	transparent = false
	$AnimationPlayer.play("RESET")


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
	await get_tree().create_timer(0.6, false).timeout
	Globals.male_deer_vulnerable = true
	$Sprite2D.material.set_shader_parameter("progress", 0)


func increment_score():
	Globals.male_deer_score += 1


func respawn():
	if player_lost:
		return

	dying = true
	Globals.male_deer_vulnerable = false
	$DeathSound.play()
#	get_node("DeerCollision").disabled = true    # disable
	await get_tree().create_timer(0.6).timeout
	dying = false
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
	cutscene_playing = true
	

func cutscene_ended():
	cutscene_playing = false
