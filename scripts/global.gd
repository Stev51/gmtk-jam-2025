extends Node

enum GameStates {RUNNING, PAUSED}
enum PlacerStates {VALID, SOFT_INVALID, HARD_INVALID, OUT_OF_BOUNDS}

var game_state = GameStates.RUNNING
