extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/GameOverScreen.visible = false
	var coins = get_tree().get_nodes_in_group("coins")
	for coin in coins:
		coin.picked_up_coin.connect(coin_collected)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_player_player_damaged() -> void:
	if "update_player_health" in $CanvasLayer/GameOverlay:
		$CanvasLayer/GameOverlay.update_player_health(Global.player_health)


func _on_player_update_wall_jump_count(count: int) -> void:
	if "update_wall_jump_count" in $CanvasLayer/GameOverlay:
		$CanvasLayer/GameOverlay.update_wall_jump_count(count)


func _on_player_player_died() -> void:
	await get_tree().create_timer(2).timeout
	#get_tree().change_scene_to_file("res://scenes/game_over_screen/game_over_screen.tscn")
	$CanvasLayer/GameOverScreen.start()


func coin_collected() -> void:
	$CanvasLayer/GameOverlay.update_coin_count(Global.coin_count)
