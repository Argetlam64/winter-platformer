extends CharacterBody2D


@export var SPEED = 100.0
@export var JUMP_VELOCITY = -300.0


func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta



	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	
		# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$SpriteAnimation.animation = "jump_up"
	
	elif direction:
		$SpriteAnimation.flip_h = velocity.x < 0
		$SpriteAnimation.animation = "run"
	
	else:
		$SpriteAnimation.animation = "idle"

	move_and_slide()
