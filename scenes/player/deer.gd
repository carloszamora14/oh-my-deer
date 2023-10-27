extends CharacterBody2D

signal game_over()
signal player_throw_candy(marker_pos, candy_direction)

const SPEED = 100.0
const JUMP_VELOCITY = -240.0
const FRICTION = 300;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var dying: bool = false
var player_lost: bool = false
var eating: bool = false
var can_throw_candy: bool = true

func _ready():
	Globals.male_deer_position = global_position
	Globals.connect("male_deer_death", respawn)

func _physics_process(delta):
	if player_lost:
		pass
		
	Globals.male_deer_position = global_position
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if (!dying):
		if Input.is_action_just_pressed("interact") and can_throw_candy:
			var marker_pos = $DeerSprite/Marker2D.global_position
#			print(marker_pos, global_position)
			var candy_direction = Vector2(1, 0) if $DeerSprite.scale.x >= 0 else Vector2(-1, 0)
			# Emit the position
			player_throw_candy.emit(marker_pos, candy_direction)
			can_throw_candy = false
			$Timer.start()
		elif Input.is_action_just_pressed("jump") and is_on_floor():
#			$AnimationPlayer.play('death')
			$IdleTimer.stop()
			$IdleTimer.start()
			velocity.y = JUMP_VELOCITY
		var direction = Input.get_axis("left", "right")
		if direction:
			$IdleTimer.stop()
			$IdleTimer.start()
			if !eating:
				$DeerSprite.play("run")
			$DeerSprite.scale.x = -1 if direction <= 0 else 1
			$DeerCollision.scale = Vector2(1 if direction >= 0 else -1, 1)
			velocity.x = direction * SPEED
		else:
			if !eating:
				$DeerSprite.play("idle")
			velocity.x = move_toward(velocity.x, 0, FRICTION)

		move_and_slide()


func hit(damage, enemy):
	Globals.update_male_deer_health(Globals.male_deer_health - damage, enemy)
	$DeerSprite.material.set_shader_parameter('progress', 0.6)
	Globals.male_deer_vulnerable = false
	if (Globals.male_deer_health > 0):
		var sound = AudioStreamPlayer.new()
		sound.stream = load("res://sounds/deer-scream1.mp3")
		add_child(sound)
		sound.play()
	await get_tree().create_timer(0.6).timeout
	Globals.male_deer_vulnerable = true
	$DeerSprite.material.set_shader_parameter('progress', 0)


func increment_score():
	Globals.male_deer_score += 1


func respawn():
	dying = true
	Globals.male_deer_vulnerable = false
	$DeathSound.play()
#	get_node("DeerCollision").disabled = true    # disable
	await get_tree().create_timer(0.6).timeout
	dying = false
	Globals.male_deer_vulnerable = true
	get_node("DeerCollision").disabled = false   # enable
	global_position = Vector2(40, 240)
	if Globals.male_deer_lives > 0:
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
		$DeerSprite.play("eat")
		await $DeerSprite.animation_finished
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
