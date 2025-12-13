extends CharacterBody2D


@export var SPEED = 100.0
@export var JUMP_VELOCITY = -300.0
@export var direction: Vector2

@onready var animator: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	direction = Input.get_vector("left", "right", "jump", "down")		
	velocity = direction * SPEED
	
	#if not is_on_floor():
		#velocity = get_gravity() * delta
	#else:
		#if Input.is_action_just_pressed("jump") :
			#velocity.y = JUMP_VELOCITY	
	animation()
	move_and_slide()
	
func animation():
	if direction:
		animator.flip_h = !direction.x > 0
		animator.play("walk")
	else:
		animator.play("idle")
