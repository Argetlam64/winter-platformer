extends Control

const wall_jump_text = "Wall jumps: "

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HealthBar.max_value = Global.max_player_health
	$FrostBar.max_value = Global.max_frost
	update_player_health(Global.player_health) 
	update_wall_jump_count(Global.max_wall_jumps)
	update_wall_jump_count(Global.max_wall_jumps)
	update_dash(Global.dash_count)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func update_player_health(health: int):
	$HealthBar.value = health

func update_wall_jump_count(count: int):
	$WallJumpCounter.text = wall_jump_text + str(count)

func update_coin_count(val: int):
	$TextureRect/CoinCount.text = ": " + str(val)

func update_wood_count(val: int):
	$TextureRect2/WoodCount.text = ": " + str(val)

func update_frost(val: int) -> void:
	$FrostBar.value = val
	$ColdLabel.text = "Cold: " + str(round((float(Global.frost) / float(Global.max_frost) * 100))) + "%"
	
func update_dash(val: int) -> void:
	$DashLabel.text = "Dash count: " + str(val)
