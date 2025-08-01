extends Node

enum GameStates {RUNNING, PAUSED}

enum CursorStates {UNSELECTED, SELECTED}
enum PlacerStates {VALID, SOFT_INVALID, HARD_INVALID}

var game_state = GameStates.RUNNING
