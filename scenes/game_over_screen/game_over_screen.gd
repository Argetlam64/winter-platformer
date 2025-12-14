extends Control

var death_timeout_finished = false

# Called when the node enters the scene tree for the first time.
func start() -> void:
	$ContinueLabel.visible = false
	$".".visible = true
	$Node2D/DeathTimer.start()
	
func back_to_game():
	Global.player_health = Global.max_player_health
	Global.wood_count = 0
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("jump") && death_timeout_finished:
		call_deferred("back_to_game")

func _on_death_timer_timeout() -> void:
	$Node2D/BlinkTimer.start()
	death_timeout_finished = true


func _on_blink_timer_timeout() -> void:
	$ContinueLabel.visible = !$ContinueLabel.visible
	print("Visible: " + str($ContinueLabel.visible))
	$Node2D/BlinkTimer.start()
