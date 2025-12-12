extends CharacterBody2D


@export var SPEED = 100.0
@export var JUMP_VELOCITY = -300.0
var is_attacking := false

func _physics_process(delta: float) -> void:
	
	#can't cancel attacking
	if is_attacking:
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
	
	
		# Handle jump.
	if is_on_floor():
		if Input.is_action_just_pressed("jump") :
			velocity.y = JUMP_VELOCITY
			$SpriteAnimation.play("jump_up")
			
		elif Input.is_action_just_pressed("attack"):
			$SpriteAnimation.play("attack")
			is_attacking = true
			
		elif direction:
			$SpriteAnimation.flip_h = velocity.x < 0
			$SpriteAnimation.play("run")
		
		elif !is_attacking:
			$SpriteAnimation.play("idle")

	move_and_slide()


#check if the animation is finished (can't cancel attack)
func _on_sprite_animation_animation_finished() -> void:
	is_attacking = false
