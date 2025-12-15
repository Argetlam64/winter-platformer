extends Area2D

signal heart_pickup

func start(pos: Vector2):
	position = pos

func destroy():
	if $AudioStreamPlayer2D.finished:
		queue_free()

func _on_body_entered(_body: Node2D) -> void:
	emit_signal("heart_pickup")
	$AnimationPlayer.play("pickup")
	$AudioStreamPlayer2D.play()
