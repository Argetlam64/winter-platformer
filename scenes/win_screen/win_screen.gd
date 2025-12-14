extends Control

var available: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func start():
	$".".visible = true
	$Timer.start()
	$WoodLabel.text = "Wood collected: " + str(Global.wood_count)
	$CoinsLabel.text = "Coins left: " + str(Global.coin_count)
	$TimeLabel.text = "Time taken: " + str(Global.time_taken) + "s"

func back_to_game():
	Global.player_health = Global.max_player_health
	Global.wood_count = 0
	Global.coin_count = 0
	Global.frost = 0
	Global.playing = true
	get_tree().change_scene_to_file("res://scenes/world.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("jump") and available:
		call_deferred("back_to_game")


func _on_timer_timeout() -> void:
	available = true
	$TextBlinkTimer.start()
	$ContinueLabel.visible = true


func _on_text_blink_timer_timeout() -> void:
	if available:
		$ContinueLabel.visible = !$ContinueLabel.visible 
