extends Node

signal stats_change()
signal score_change()
signal hunger_change()
signal taking_hunger_damage()
signal male_deer_death()
signal female_deer_death()
signal falling

var reducing_life_instantaneously: bool = true
var game_loaded: bool = false
var male_deer_falling: bool = false:
	set(value):
		male_deer_falling = value
		if value:
			falling.emit()
var male_deer_position: Vector2
var male_deer_lives: int = 3
var male_deer_vulnerable: bool = true
var male_deer_health: int = 100
var male_deer_score: int = 0:
	set(value):
		male_deer_score = value
		score_change.emit()
var male_deer_hunger: int = 5:
	set(value):
		if value >= 5:
			male_deer_hunger = 5
		elif value < 0:
			taking_hunger_damage.emit()
			male_deer_hunger = 0
		else:
			male_deer_hunger = value
		
		hunger_change.emit()

var female_deer_lives: int = 3
var female_deer_vulnerable: bool = true
var female_deer_health: int = 100

var bullet_impact_sounds = [
	"res://sounds/bullet-impact1.mp3",
	"res://sounds/bullet-impact2.mp3",
	"res://sounds/bullet-impact3.mp3",
]

func update_male_deer_health(value, enemy):
	if !male_deer_vulnerable && value < male_deer_health:
		return
	if value > male_deer_health:
		male_deer_health = min(100, value)
	elif male_deer_vulnerable:
		male_deer_vulnerable = false
		male_deer_health = max(0, value)
		male_deer_invulnerable_timer()
	if (male_deer_health <= 0):
		if enemy != null && "reset_target" in enemy:
			enemy.reset_target()
		if reducing_life_instantaneously:
			male_deer_lives -= 1
		male_deer_death.emit()
	stats_change.emit()


func male_deer_invulnerable_timer():
	await get_tree().create_timer(0.5).timeout
	male_deer_vulnerable = true


func update_female_deer_health(value, enemy):
	if value > female_deer_health:
		female_deer_health = min(100, value)
	elif female_deer_vulnerable:
		female_deer_vulnerable = false
		female_deer_health = max(0, value)
		female_deer_invulnerable_timer()
	if (female_deer_health <= 0):
		if "reset_target" in enemy:
			enemy.reset_target()
		female_deer_lives -= 1
		female_deer_death.emit()
	stats_change.emit()


func female_deer_invulnerable_timer():
	await get_tree().create_timer(0.5).timeout
	female_deer_vulnerable = true


func play_bullet_impact(sound_position):
	var sound = AudioStreamPlayer2D.new()
	sound.stream = load(bullet_impact_sounds.pick_random())
	sound.global_position = sound_position
	add_child(sound)
	sound.play()
	await sound.finished
	sound.queue_free()
	
