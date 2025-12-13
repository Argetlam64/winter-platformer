extends CharacterBody2D

@export var speed := 100.0
@export var jump_strength := -350.0
@export var gravity := 1000
@export var wall_slide_speed := 500
@export var wall_jump_cooldown := 1
var can_wall_jump = true
var wall_jump_pushback = 500
var direction_x: float

func _physics_process(delta):
	direction_x = Input.get_axis("left", "right")
	apply_gravity(delta)
	apply_direction()
	jump(delta)
	animation()
	move_and_slide()

func apply_direction():
	if direction_x:
		velocity.x = direction_x * speed
	else:
		velocity.x = 0
	if (Input.is_action_pressed("right") or Input.is_action_pressed("left")) and is_on_wall():
		velocity.y = 50

func jump(delta):
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_strength
		if is_on_wall() and not is_on_floor() and can_wall_jump:
			start_wall_jump_cooldown()
			if Input.is_action_pressed('right'):
				velocity.y = jump_strength
				velocity.x = -wall_jump_pushback
			elif Input.is_action_pressed('left'):
				velocity.y = jump_strength
				velocity.x = wall_jump_pushback

func apply_gravity(delta):
	velocity.y += gravity * delta

func start_wall_jump_cooldown():
	can_wall_jump = false
	await get_tree().create_timer(wall_jump_cooldown).timeout
	can_wall_jump = true

func animation():
	$Sprite2D.flip_h = direction_x > 0
	if is_on_floor():
		$AnimationPlayer.current_animation = 'run' if direction_x else 'idle'
	else:
		$AnimationPlayer.current_animation = 'jump'
