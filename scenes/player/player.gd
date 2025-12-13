extends CharacterBody2D


@export var SPEED = 100.0
@export var JUMP_VELOCITY = -300.0
var is_attacking := false
var enemy: CharacterBody2D
var alive: bool = true

signal player_died

func _physics_process(delta: float) -> void:
	#can't cancel attacking
	if is_attacking or !alive:
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		$SpriteAnimation.flip_h = velocity.x < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	
	if Input.is_action_just_pressed("jump") and( is_on_wall() or is_on_floor()):
			velocity.y = JUMP_VELOCITY
			$SpriteAnimation.play("jump_up")
			
		# Handle jump.
	if is_on_floor():	
		if Input.is_action_just_pressed("attack"):
			$SpriteAnimation.play("attack")
			$AnimationPlayer.play("attack")
			is_attacking = true
			
		elif direction:
			$SpriteAnimation.flip_h = velocity.x < 0
			$SpriteAnimation.play("run")
		
		elif !is_attacking:
			$SpriteAnimation.play("idle")

	move_and_slide()


func attack() -> void:
	if enemy:
		if "reduce_hp" in enemy:
			enemy.reduce_hp()

#check if the animation is finished (can't cancel attack)
func _on_sprite_animation_animation_finished() -> void:
	is_attacking = false
		

func _on_area_2d_body_entered(body: Node2D) -> void:
	enemy = body as CharacterBody2D


func _on_area_2d_body_exited(_body: Node2D) -> void:
	enemy = null
	
	
func player_die():
	$SpriteAnimation.play("death")
	alive = false
	emit_signal("player_died")

func flash_player():
	var original = $".".modulate
	$".".modulate = Color(255, 255, 255)
	velocity.y += 5
	await get_tree().create_timer(0.2).timeout
	$".".modulate = original

func damage_player():
	if Global.player_health <= 0:
		return
		
	Global.player_health -= 1
	print("Player health: " + str(Global.player_health))
	if Global.player_health <= 0:
		player_die()
	flash_player()
