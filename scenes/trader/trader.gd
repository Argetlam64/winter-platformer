extends Area2D

var available: bool = false
signal traded_for_wood

func set_visibility(val: bool):
	$WoodArrow.visible = val
	$SubViewport/Control/Label.visible = val

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact") and available:
		trade_for_wood()
	
	set_visibility(available)


func throw_wood():
	var wood_scene = preload("res://scenes/wood/wood_item.tscn")
	var wood = wood_scene.instantiate()
	wood.setup($Marker2D.position)
	$WoodItems.add_child(wood)
	wood.start()
	
	
		

func trade_for_wood():
	if Global.coin_count > 0:
		for i in range(min(Global.coin_count, 5)):
			throw_wood()
			await get_tree().create_timer(0.2).timeout
			
		Global.wood_count += Global.coin_count
		Global.coin_count = 0
		emit_signal("traded_for_wood")

func _on_body_entered(_body: Node2D) -> void:
	available = true
	

func _on_body_exited(_body: Node2D) -> void:
	available = false
	
