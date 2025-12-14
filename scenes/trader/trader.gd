extends Area2D

var available: bool = false
signal traded_for_wood


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact") and available:
		trade_for_wood()
	
	$WoodArrow.visible = available


func trade_for_wood():
	Global.wood_count += Global.coin_count
	Global.coin_count = 0
	emit_signal("traded_for_wood")
	


func _on_body_entered(_body: Node2D) -> void:
	available = true
	

func _on_body_exited(_body: Node2D) -> void:
	available = false
	
