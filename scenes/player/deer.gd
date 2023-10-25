extends CharacterBody2D

signal game_over()

const SPEED = 100.0
const JUMP_VELOCITY = -240.0
const FRICTION = 300;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var dying: bool = false
var player_lost: bool = false
var eating: bool = false

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
		if Input.is_action_just_pressed("jump") and is_on_floor():
			$IdleTimer.stop()
			$IdleTimer.start()
			velocity.y = JUMP_VELOCITY
		var direction = Input.get_axis("left", "right")
		if direction:
			$IdleTimer.stop()
			$IdleTimer.start()
			if !eating:
				$DeerSprite.play("run")
			$DeerSprite.flip_h = direction <= 0
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
	await get_tree().create_timer(0.6).timeout
	Globals.male_deer_vulnerable = true
	$DeerSprite.material.set_shader_parameter('progress', 0)


func increment_score():
	Globals.male_deer_score += 1


func respawn():
	dying = true
	Globals.male_deer_vulnerable = false
	$DeathSound.play()
	get_node("DeerCollision").disabled = true    # disable
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
