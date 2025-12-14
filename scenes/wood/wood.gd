extends Area2D


func _on_body_entered(_body: Node2D) -> void:
	$WoodArrow.visible = true


func _on_body_exited(_body: Node2D) -> void:
	$WoodArrow.visible = false
