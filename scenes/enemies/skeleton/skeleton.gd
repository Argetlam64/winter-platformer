extends CharacterBody2D

var direction: Vector2 = Vector2.ZERO
var player: CharacterBody2D
var speed: int = 40
var attacking = false
var player_in_area = false
var original_pos = position
var health_points: int = 3

signal enemy_die(pos: Vector2)


func _physics_process(delta: float) -> void:
	if !Global.playing:
		return 
		
	velocity = Vector2(0, velocity.y)
	if not is_on_floor():
		velocity += get_gravity() * delta
	

		
	if attacking or health_points <= 0:
		move_and_slide()
		return

	if direction.x:
		$AnimatedSprite2D.flip_h = direction.x < 0
		
	if player:
		#var player_direction = (player.global_position - global_position).normalized()
		var dx = player.global_position.x - global_position.x
		if abs(dx) > 6:
			direction.x = sign(dx)
			$AnimatedSprite2D.play("walking")
		else:
			direction.x = 0
			
		velocity.x = direction.x * speed
	else:
		$AnimatedSprite2D.play("idle")
		
	
	move_and_slide()


func _on_detection_area_body_entered(body: Node2D) -> void:
	#print("Detected player")
	player = body as CharacterBody2D
	
	
func attack():
	
	$AnimatedSprite2D.play("attack")
	attacking = true
	$AnimationPlayer.play("attack")

func _on_attack_area_body_entered(_body: Node2D) -> void:
	if health_points > 0:
		attack()
		player_in_area = true
		$Timers/AttackTimer.start()
		
func _on_attack_area_body_exited(_body: Node2D) -> void:
	player_in_area = false

func _on_animated_sprite_2d_animation_finished() -> void:
	attacking = false
		

func _on_attack_timer_timeout() -> void:
	#print("Player_in_area: " + str(player_in_area))
	if player_in_area:
		attack()
		$Timers/AttackTimer.start()

func flash_skeleton():
	var original = $".".modulate
	$".".modulate = Color(255, 255, 255)
	velocity.y += 5
	await get_tree().create_timer(0.2).timeout
	$".".modulate = original
	
func skeleton_die():
	$AnimatedSprite2D.play("death")
	$Timers/AttackTimer.stop()
	$".".set_collision_layer_value(3, false)
	$".".set_collision_mask_value(2, false)
	emit_signal("enemy_die", global_position)
	

func reduce_hp():
	$Sounds/Damaged.play()
	flash_skeleton()
	health_points -= 1
	#print("Lost hp, " + str(health_points) + " left.")
	if health_points <= 0:
		skeleton_die()
		
func hit_player():
	$Sounds/Slash.play()
	#print("Hit player called")
	if player_in_area:
		#print("Player in area")
		if "damage_player" in player and health_points > 0:
			player.damage_player()
