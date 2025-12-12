extends CharacterBody2D

var direction: Vector2
var speed: int = 10

func _physics_process(delta: float) -> void:
	direction = Input.get_vector("left", "right", "jump", "down")		
	velocity += direction * speed
	move_and_slide()
	
