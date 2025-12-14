extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/GameOverScreen.visible = false
	$CanvasLayer/GameOverlay.visible = true
	var coins = get_tree().get_nodes_in_group("coins")
	var traders = get_tree().get_nodes_in_group("trader")
	for coin in coins:
		coin.picked_up_coin.connect(coin_collected)
	
	for trader in traders:
		trader.traded_for_wood.connect(traded)


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
	
func traded() -> void:
	$CanvasLayer/GameOverlay.update_coin_count(Global.coin_count)
	$CanvasLayer/GameOverlay.update_wood_count(Global.wood_count)
	$Fire.update_wood_text(Global.wood_count)


func _on_frost_timer_timeout() -> void:
	Global.frost += 1
	$CanvasLayer/GameOverlay.update_frost(Global.frost)
	$Player.change_frost_radius(Global.frost)
	if Global.frost >= Global.max_frost:
		$Player.damage_player()


func _on_fire_fire_lit() -> void:
	for i in range(Global.max_frost * 5):
		Global.frost -= 1
		await get_tree().create_timer(0.1).timeout
		$CanvasLayer/GameOverlay.update_frost(Global.frost)
		$Player.change_frost_radius(Global.frost)
