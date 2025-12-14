extends Control

const wall_jump_text = "Wall jumps: "

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HealthBar.max_value = Global.max_player_health
	$HealthBar.value = Global.player_health
	$WallJumpCounter.text = wall_jump_text + str(Global.max_wall_jumps)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func update_player_health(health: int):
	$HealthBar.value = health

func update_wall_jump_count(count: int):
	$WallJumpCounter.text = wall_jump_text + str(count)

func update_coin_count(val: int):
	$CoinCount.text = ": " + str(val)

func update_wood_count(val: int):
	$WoodCount.text = ": " + str(val)
