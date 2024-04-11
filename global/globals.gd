extends Node

signal stats_change
signal hunger_change
signal taking_hunger_damage
signal death
signal falling

var is_player_falling := false:
	set(value):
		is_player_falling = value
		if value:
			falling.emit()

var player_health := 100:
	set(value):
		if value < 0:
			death.emit()
		player_health = max(0, min(value, 100))
		stats_change.emit()

var player_hunger := 5:
	set(value):
		if value < 0:
			taking_hunger_damage.emit()
		player_hunger = max(0, min(value, 5))
		hunger_change.emit()

var player_position: Vector2
var player_lives := 3

func _ready() -> void:
	var file = FileAccess.open("res://data/dialogues.json", FileAccess.READ)
	var text_content = file.get_as_text()
	#print(JSON.parse_string(text_content))


func play_bullet_impact(sound_position: Vector2) -> void:
	var bullet_impact_sounds = [
		"res://sounds/bullet-impact1.mp3",
		"res://sounds/bullet-impact2.mp3",
		"res://sounds/bullet-impact3.mp3",
	]

	var sound = AudioStreamPlayer2D.new()
	sound.stream = load(bullet_impact_sounds.pick_random())
	sound.global_position = sound_position
	add_child(sound)
	sound.play()
	await sound.finished
	sound.queue_free()
