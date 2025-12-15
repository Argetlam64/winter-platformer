extends Node

const max_player_health: int = 6
const max_wall_jumps: int = 2
const max_frost: int = 600
const max_player_light_scale = 10
const required_wood: int = 100
const heart_drop_chance: float = 0.3
const max_dash_count = 2

var player_health: int = max_player_health
var wood_count: int = 0
var coin_count: int = 0
var frost: int = 0
var time_taken: int = 0
var pause = false
var enemies_killed = 0
var dash_count = 2

var playing = true

func reset_global_state():
	player_health = max_player_health
	frost = 0
	coin_count = 0
	wood_count = 0
	enemies_killed = 0
	pause = false
	playing = true
	time_taken = 0
