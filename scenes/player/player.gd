extends CharacterBody2D


@export var SPEED = 100.0
@export var JUMP_VELOCITY = -300.0
var is_attacking := false

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_attacking:
		return
		
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	$SpriteAnimation.flip_h = velocity.x < 0
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


func _on_sprite_animation_animation_finished() -> void:
	print("finished animation")
	is_attacking = false
