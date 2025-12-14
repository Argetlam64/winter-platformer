extends Area2D

var available: bool = false

signal fire_lit

func show_overlay(val: bool):
	if val:
		if Global.wood_count >= Global.required_wood:
			$SufficientOverlay.visible = true
			$InsufficientOverlay.visible = false
		else:
			$SufficientOverlay.visible = false
			$InsufficientOverlay.visible = true
	else:
		$SufficientOverlay.visible = false
		$InsufficientOverlay.visible = false
		
func _ready() -> void:
	update_wood_text(Global.wood_count)
	show_overlay(false)

func _process(_delta: float) -> void:
	if Global.wood_count >= Global.required_wood and Input.is_action_just_pressed("interact") and available:
		$Sprite2D.play("lit")
		emit_signal("fire_lit")

func _on_body_entered(_body: Node2D) -> void:
	available = true
	show_overlay(true)

func _on_body_exited(_body: Node2D) -> void:
	available = false
	show_overlay(false)

func update_wood_text(val: int):
	var wood_string = str(val) + "/" + str(Global.required_wood) + " wood"
	$InsufficientOverlay/SubViewport2/Control2/Label2.text = wood_string
