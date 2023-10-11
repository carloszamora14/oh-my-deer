extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -200.0
const FRICTION = 300;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	Globals.connect("male_deer_death", respawn)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
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


func respawn():
	if Globals.male_deer_lives > 0:
		global_position = Vector2(40, 240)
		Globals.male_deer_health = 100
	else:
		hide()
