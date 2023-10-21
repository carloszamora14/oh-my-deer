extends Node

signal stats_change()
signal male_deer_death()
signal female_deer_death()

var male_deer_lives: int = 3
var male_deer_vulnerable: bool = true
var male_deer_health: int = 100
var male_deer_score: int = 0:
	set(value):
		male_deer_score = value
		stats_change.emit()

var female_deer_lives: int = 3
var female_deer_vulnerable: bool = true
var female_deer_health: int = 100

func update_male_deer_health(value, enemy):
	if value > male_deer_health:
		male_deer_health = min(100, value)
	elif male_deer_vulnerable:
		male_deer_vulnerable = false
		male_deer_health = max(0, value)
		male_deer_invulnerable_timer()
	if (male_deer_health <= 0):
		if "reset_target" in enemy:
			enemy.reset_target()
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
