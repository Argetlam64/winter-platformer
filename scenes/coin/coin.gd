extends Area2D

signal picked_up_coin
var available: bool = false
var exists: bool = true

func set_item_visible(val: bool):
	$WoodArrow.visible = val
	$SubViewport/Control/Label.visible = val

func _ready() -> void:
	set_item_visible(false)
	

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact") and available:
		pickup()


func _on_body_entered(_body: Node2D) -> void:
	set_item_visible(true)
	available = true


func _on_body_exited(_body: Node2D) -> void:
	set_item_visible(false)
	available = false


func pickup():
	if exists:
		Global.coin_count += 1
		exists = false
		$AnimationPlayer.play("pickup")
		emit_signal("picked_up_coin")

func destroy():
	queue_free()
	print("Coin picked up")
	
