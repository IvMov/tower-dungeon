extends Node
# TODO: after add saving and different players, add method to update var values from saving

const BASE_SPEED: float = 300.0
const BASE_JUMP_VELOCITY: float = 500.0
const BASE_AIR_SPEED: float = 150.0 # not work as need to adjust velocity in process method for player
const MOVE_SPEED_UP_MOD: float = 1.5
const JUMP_SPEED_UP_MOD: float = 1.2

var current_speed: float = BASE_SPEED
var current_air_speed: float = BASE_AIR_SPEED
var current_jump_velocity: float = BASE_JUMP_VELOCITY
var max_jumps: int = 50
