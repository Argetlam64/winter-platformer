extends CharacterBody2D


@export var SPEED = 100.0
@export var JUMP_VELOCITY = -300.0
var is_attacking := false
var enemy: CharacterBody2D
var alive: bool = true
var current_wall_jumps: int = Global.max_wall_jumps

var dash_speed = 350
var dash_time = 0.2
var last_direction = 1
var is_dashing = false
var can_dash = true
var invincible = false

signal player_died
signal player_damaged
signal update_wall_jump_count(count: int)

func start_dash():
	is_dashing = true
	can_dash = false
	velocity.y = 0
	$DashTimer.start()
	$SpriteAnimation.play("dash")
	$DashCooldown.start()

func _physics_process(delta: float) -> void:
	if !Global.playing:
		return 
	#can't cancel attacking
	if is_attacking or !alive:
		return
	
	if is_dashing:
		velocity.x = last_direction * dash_speed
		move_and_slide()
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	elif current_wall_jumps < Global.max_wall_jumps:
		current_wall_jumps = Global.max_wall_jumps
		emit_signal("update_wall_jump_count", Global.max_wall_jumps)
		
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		last_direction = direction
		$SpriteAnimation.flip_h = velocity.x < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_just_pressed("dash") and can_dash: 
		start_dash()
		return
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$SpriteAnimation.play("jump_up")
	
	elif Input.is_action_just_pressed("jump") and is_on_wall() and current_wall_jumps > 0:
		current_wall_jumps -= 1
		velocity.y = JUMP_VELOCITY
		$SpriteAnimation.play("jump_up")
		emit_signal("update_wall_jump_count", current_wall_jumps)
			
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
	if Global.player_health <= 0 or invincible:
		return
	
		
	Global.player_health -= 1
	invincible = true
	$DamageCooldown.start()
	emit_signal("player_damaged")
	print("Player health: " + str(Global.player_health))
	if Global.player_health <= 0:
		player_die()
	flash_player()
	
func change_frost_radius(val: float):
	var new_radius = Global.max_player_light_scale - Global.max_player_light_scale * val / Global.max_frost
	if new_radius >= 0:
		$PointLight2D.texture_scale = new_radius
		#print("New radius:" + str(new_radius))
	


func _on_dash_timer_timeout() -> void:
	is_dashing = false


func _on_dash_cooldown_timeout() -> void:
	can_dash = true


func _on_damage_cooldown_timeout() -> void:
	invincible = false
