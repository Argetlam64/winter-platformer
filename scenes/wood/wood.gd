extends Area2D

func _ready() -> void:
	$WoodArrow.visible = false

func set_item_visible(val: bool):
	$WoodArrow.visible = val

func _on_body_entered(_body: Node2D) -> void:
	set_item_visible(true)


func _on_body_exited(_body: Node2D) -> void:
	set_item_visible(false)
