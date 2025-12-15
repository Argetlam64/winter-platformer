extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/GameOverScreen.visible = false
	$CanvasLayer/GameOverlay.visible = true
	$CanvasLayer/PauseOverlay.visible = false
	var coins = get_tree().get_nodes_in_group("coins")
	var traders = get_tree().get_nodes_in_group("trader")
	var skeletons = get_tree().get_nodes_in_group("skeletons")
	for coin in coins:
		coin.picked_up_coin.connect(coin_collected)
	
	for trader in traders:
		trader.traded_for_wood.connect(traded)
	
	for skeleton in skeletons:
		skeleton.enemy_die.connect(enemy_killed)

func pause_toggle():
	Global.pause = !Global.pause
	Global.playing = !Global.playing
	$CanvasLayer/PauseOverlay.visible = Global.pause

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pause_toggle()
	elif Input.is_action_just_pressed("restart") and Global.pause:
		call_deferred("restart_game")
	elif Input.is_action_just_pressed("quit") and Global.pause:
		get_tree().quit()

func enemy_killed(pos: Vector2):
	var coin_scene = preload("res://scenes/coin/coin.tscn")
	var heart_scene = preload("res://scenes/heart/heart.tscn")
	Global.enemies_killed += 1
	for i in range(3):
		var coin = coin_scene.instantiate() as Area2D
		coin.start(pos)
		coin.picked_up_coin.connect(coin_collected)
		$Coins.add_child(coin)
		await get_tree().create_timer(0.2).timeout
	if randf() < Global.heart_drop_chance:
		var heart = heart_scene.instantiate() as Area2D
		heart.start(pos)
		heart.heart_pickup.connect(heal_player)
		$Coins.add_child(heart)
		
	
func heal_player():
	if Global.player_health < Global.max_player_health:
		Global.player_health += 1
		$CanvasLayer/GameOverlay.update_player_health(Global.player_health)

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
	if Global.playing:
		Global.frost += 1
		Global.time_taken += 1
		$CanvasLayer/GameOverlay.update_frost(Global.frost)
		$Player.change_frost_radius(Global.frost)
		if Global.frost >= Global.max_frost:
			$Player.damage_player()


func _on_fire_fire_lit() -> void:
	Global.playing = false
	$CanvasLayer/WinScreen.start()
	
	while Global.frost > 0:	
		Global.frost -= 1
		await get_tree().create_timer(0.1).timeout
		$CanvasLayer/GameOverlay.update_frost(Global.frost)
		$Player.change_frost_radius(Global.frost)


func _on_player_update_dash_count() -> void:
	$CanvasLayer/GameOverlay.update_dash(Global.dash_count)
	
func restart_game():
	Global.reset_global_state()
	get_tree().change_scene_to_file("res://scenes/world.tscn")
