extends Node2D

func _process(delta: float) -> void:
	if Input.is_action_pressed("interact"):
		get_tree().change_scene_to_file("res://scenes/world.tscn")
