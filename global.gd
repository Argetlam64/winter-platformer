extends Node

const max_player_health: int = 6
const max_wall_jumps: int = 2
const max_frost: int = 360
const max_player_light_scale = 10
const required_wood: int = 100
const heart_drop_chance: float = 0.3

var player_health: int = max_player_health
var wood_count: int = 0
var coin_count: int = 0
var frost: int = 0
var time_taken: int = 0

var playing = true
