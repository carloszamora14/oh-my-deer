extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -200.0
const FRICTION = 300;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	Globals.connect("female_deer_death", respawn)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		$DeerFemaleSprite.play("run")
		$DeerFemaleSprite.flip_h = direction <= 0
		$DeerFemaleCollision.scale = Vector2(1 if direction >= 0 else -1, 1)
		velocity.x = direction * SPEED
	else:
		$DeerFemaleSprite.play("idle")
		velocity.x = move_toward(velocity.x, 0, FRICTION)

	move_and_slide()

func hit(damage, enemy):
	Globals.update_female_deer_health(Globals.female_deer_health - damage, enemy)


func respawn():
	if Globals.female_deer_lives >= 0:
		global_position = Vector2(40, 240)
		Globals.female_deer_health = 100
	else:
		queue_free()
