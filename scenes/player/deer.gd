extends CharacterBody2D

signal game_over()

const SPEED = 100.0
const JUMP_VELOCITY = -200.0
const FRICTION = 300;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var dying: bool = false
var player_lost: bool = false

func _ready():
	Globals.connect("male_deer_death", respawn)

func _physics_process(delta):
	if player_lost:
		pass
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if (!dying):
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		
		var direction = Input.get_axis("left", "right")
		if direction:
			$DeerSprite.play("run")
			$DeerSprite.flip_h = direction <= 0
			$DeerCollision.scale = Vector2(1 if direction >= 0 else -1, 1)
			velocity.x = direction * SPEED
		else:
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
	$DeathSound.play()
	get_node("DeerCollision").disabled = true    # disable
	await get_tree().create_timer(0.6).timeout
	dying = false
	get_node("DeerCollision").disabled = false   # enable
	if Globals.male_deer_lives > 0:
		Globals.male_deer_health = 100
		global_position = Vector2(40, 240)
	else:
		player_lost = true
		get_node("DeerCollision").disabled = true   # enable
		global_position = Vector2(40, 240)
		game_over.emit()
		hide()
	
