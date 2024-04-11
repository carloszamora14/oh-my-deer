class_name ChasingController
extends HunterController


func _physics_process(_delta: float) -> void:
	if actor.prey != null:
		var movement_input = (
			int(actor.global_position.x < actor.prey.global_position.x) -
			int(actor.global_position.x > actor.prey.global_position.x)
		)
		
		if actor.prey_in_notice_area:
			movement_input = 0
			
			if actor.prey_in_kick_area and actor.can_kick and not actor.is_shooting:
				kick_command.execute(actor)
			elif actor.can_shoot and not actor.is_kicking:
				shoot_command.execute(actor, shoot_command.Params.new("Player"))
		
		if actor.is_on_wall() and actor.can_jump and not actor.is_shooting and not actor.is_kicking:
				jump_command.execute(actor)
		
		movement_command.execute(actor, MovementCommand.Params.new(movement_input))
	
	#if !inactive:
		#var should_follow = !(is_in_shooting_area && global_position.x < target.global_position.x)
		#
		#if chasing && target != null:	
			#if sees_deer || !should_follow:
				#move_left = false
				#move_right = false
			#elif global_position.x > target.global_position.x:
				#move_left = true
				#move_right = false
			#else:
				#move_right = true
				#move_left = false
			#
		#if is_in_shooting_area && target != null && global_position.x + 300 <= target.global_position.x && !is_playing_sound:
			#if !text_come_back:
				#text_come_back = true
				#play_sound("come back here")
			#elif !coward && global_position.x + 800 <= target.global_position.x:
				#coward = true
				#play_sound('dont be a coward')
			#
		#if (allow_to_aim && aiming) || (target != null && !should_follow) && !is_waving:
			#var pos = get_global_mouse_position() if target == null else target.global_position
			#if abs(pos.x - global_position.x) >= 40:
				#if pos.x < global_position.x:
					#$Sprites.scale.x = -abs($Sprites.scale.x)
					#$SpriteRunning.scale.x = -abs($SpriteRunning.scale.x)
					#$ShoulderMark.scale.x = -1
					#$CollisionShape2D.position.x = 7.2
				#else:
					#$Sprites.scale.x = abs($Sprites.scale.x)
					#$SpriteRunning.scale.x = abs($SpriteRunning.scale.x)
					#$ShoulderMark.scale.x = 1
					#$CollisionShape2D.position.x = 0
				#if target == null:
					#var mouse_position = get_global_mouse_position()
					#pos = mouse_position
				##	var mouse_offset = get_local_mouse_position()
					#angle = ((mouse_position - $ShoulderMark.global_position).normalized()).angle()
				#else:
					#pos = target.global_position
					#angle = ((target.global_position - $ShoulderMark.global_position).normalized()).angle()
					#
				#if !target || dont_aim:
					#angle = PI/8
				#$Sprites/LeftContainer.rotation = (PI - angle) if pos.x < global_position.x else angle
				#$Sprites/RightContainer.rotation = (PI - angle) if pos.x < global_position.x else angle
			#elif is_in_kicking_area && !is_kicking && !is_waving:
				#kick()
			#elif should_wave && !is_waving && !is_kicking:
				#wave_animate()
			#
			#if looking_for_deer && (sees_deer || !should_follow) && can_shoot && !is_waving && !is_kicking:
				#shoot_rifle(0)
				#can_shoot = false
				#$Timer.start()
#
#
		#if !is_shooting && !is_kicking && !is_waving:
			#if move_right:
				#velocity.x = SPEED
				#$AnimationPlayer.play("run")
			#elif move_left:
				#velocity.x = -SPEED
				#$AnimationPlayer.play("run")
			#else:
				#velocity.x = move_toward(velocity.x, 0, SPEED)
				#$AnimationPlayer.play("RESET")
		#else:
			#velocity.x = move_toward(velocity.x, 0, SPEED)
#
#
	#if not is_on_floor():
		#velocity.y += gravity * delta
		#
	#move_and_slide()
	#
	#if !inactive:
		#if is_on_wall() && is_on_floor() && !is_shooting && !sees_deer:
			#velocity.y += JUMP_VELOCITY
	#elif velocity.x != 0:
		#$AnimationPlayer.play("RESET")
		#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	#
#func shot_sound():
	#var sound = AudioStreamPlayer.new()
	#sound.stream = load("res://sounds/hunter/GUNAuto_Shot beretta m12 9 mm (ID 0437)_BSB.mp3")
	#add_child(sound)
	#sound.play()
	#await sound.finished
#
#
#func handle_is_playing_sound(sound_name):
	#is_playing_sound = true
	#var times = phrases[sound_name][2]
	#var total_time = 0
	#for time in times:
		#total_time += time
	#
	#await get_tree().create_timer(total_time, false).timeout
	#is_playing_sound = false
#
#
#func shoot_rifle(damage):
	#is_shooting = true
	#if damage:
		#bullet_damage = damage
	#$AnimationPlayer.play("shoot")
	#await $AnimationPlayer.animation_finished
	#is_shooting = false
	#bullet_damage = 0
	#$AnimationPlayer.play("RESET")
#
#
#func kick():
	#dont_aim = true
	#is_kicking = true
	#$AnimationPlayer.play("kick")
	#await $AnimationPlayer.animation_finished
	#is_kicking = false
	#dont_aim = false
	#$AnimationPlayer.play("RESET")
	#can_shoot = false
	#$Timer.start()
#
#
#
#
#func kick_damage():
	#if target_body != null && "get_kick" in target_body && can_do_kick_damage:
		#target_body.get_kick(self)
#
#
#func emit_bullet():
	#var gun_nozzle_position = $Sprites/RightContainer/Rifle/GunNozzle.global_position
	#var bullet_direction
	#if target == null:
		#var mouse_position = get_global_mouse_position()
		#bullet_direction = (mouse_position - $ShoulderMark.global_position).normalized()
	#else:
		#bullet_direction = (target.global_position - $ShoulderMark.global_position).normalized()
	#hunter_shot_bullet.emit(gun_nozzle_position, bullet_direction, bullet_damage)
#
#
#func _on_timer_timeout():
	#can_shoot = true
#
#
#func _on_notice_area_body_entered(_body):
	#aiming = true
	#sees_deer = true
#
#
#func _on_notice_area_body_exited(_body):
	#if !is_shooting:
		#$AnimationPlayer.play("RESET")
	#sees_deer = false
	#aiming = false
#
#
#func deer_fall():
	#if get_tree().get_current_scene().get_name() == 'Lake' && !is_playing_sound:
		#var sound_name = "idiot that wasnt the best" if randf() > 0.5 else "gotcha that serves you right"
		#play_sound(sound_name)
#
#
#func deer_died():
	#if get_tree().get_current_scene().get_name() == 'Lake' && !is_playing_sound:
		#var sound_name = "deer season" if randf() > 0.5 else "got it done"
		#play_sound(sound_name)
#
#
#func _on_attack_area_body_entered(body):
	#if "hit" in body:
		#body.hit(50, self)
#
#
#func threaten():
	#if get_tree().get_current_scene().get_name() == 'Lake' && !is_playing_sound:
		#var sound_name = "not a game anymore"
		#play_sound(sound_name)
#
#
#func play_sound(sound_name):
	#handle_is_playing_sound(sound_name)
	#var sound = AudioStreamPlayer2D.new()
	#sound.stream = load(phrases[sound_name][0])
	#sound.global_position = global_position
	#add_child(sound)
	#emit_display_dialog(sound_name)
	#sound.play()
	#await sound.finished
	#sound.queue_free()
#
#
#func coyotes_gotta_eat():
	#play_sound("coyotes gotta eat")
#
#
#func smoked_him():
	#play_sound("i smoked him")
#
#
#func come_here_deer():
	#play_sound("come here deer")
#
#
#func dont_run():
	#play_sound("dont run")
#
#
#func if_i_dont_kill_you():
	#play_sound("if i dont kill you")
#
#
#func emit_display_dialog(phrase):
	#var lines = phrases[phrase][1]
	#var timings = phrases[phrase][2]
	#display_dialog.emit(lines, timings)
#
#
#func look_what_i_found():
	#play_sound("look what i found")
#
#
#func start_chasing_deer(deer_marker):
	#looking_for_deer = true
	#aiming = false
	#move_right = true
	#target = deer_marker
	#await get_tree().create_timer(1.3, false).timeout
	#$AnimationPlayer.play("RESET")
	#$Sprites/LeftContainer.rotation = PI/8
	#$Sprites/RightContainer.rotation = PI/8
	#move_right = false
	#await get_tree().create_timer(3.4, false).timeout
	#allow_to_aim = true
	#chasing = true
	#
#
#
#func _on_kick_area_body_entered(body):
	#target_body = body
	#is_in_kicking_area = true
	#if get_tree().get_current_scene().get_name() == 'Lake' && !deer_got_close && !is_playing_sound:
		#deer_got_close = true
		#var sound_name = "dont test me" if randf() > 0.5 else "keep your distance"
		#play_sound(sound_name)
#
#
#func _on_kick_area_body_exited(_body):
	#is_in_kicking_area = false
#
#
#
#func _on_waving_area_body_exited(_body):
	#is_in_waving_area = false
	#should_wave = false
	#$WavingTimer.stop()
#
#
#func _on_waving_timer_timeout():
	#if is_in_waving_area:
		#should_wave = true
#
#
#func _on_kick_damage_area_body_entered(_body):
	#can_do_kick_damage = true
#
#
#func _on_kick_damage_area_body_exited(_body):
	#can_do_kick_damage = false
