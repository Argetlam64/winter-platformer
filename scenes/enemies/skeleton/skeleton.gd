extends CharacterBody2D

var direction: Vector2 = Vector2.ZERO
var player: CharacterBody2D
var speed: int = 40
var attacking = false
var player_in_area = false
var original_pos = position

func _physics_process(delta: float) -> void:
	velocity = Vector2(0, velocity.y)
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if attacking:
		move_and_slide()
		return

	
	if direction.x:
		$AnimatedSprite2D.flip_h = direction.x < 0
		
	if player:
		var player_direction = (player.global_position - global_position).normalized()
		if player_direction.x > 0:
			direction = Vector2(1, 0)
			$AnimatedSprite2D.play("walking")
		else:
			direction = Vector2(-1, 0)
			$AnimatedSprite2D.play("walking")
			
		velocity = direction * speed
	else:
		$AnimatedSprite2D.play("idle")
		
	
	move_and_slide()


func _on_detection_area_body_entered(body: Node2D) -> void:
	print("Detected player")
	player = body as CharacterBody2D
	
	
func attack():
	$AnimatedSprite2D.play("attack")
	attacking = true
	

func _on_attack_area_body_entered(body: Node2D) -> void:
	attack()
	player_in_area = true
	$Timers/AttackTimer.start()

func _on_attack_area_body_exited(body: Node2D) -> void:
	player_in_area = false

func _on_animated_sprite_2d_animation_finished() -> void:
	attacking = false

func _on_attack_timer_timeout() -> void:
	print("Player_in_area: " + str(player_in_area))
	if player_in_area:
		attack()
		$Timers/AttackTimer.start()
