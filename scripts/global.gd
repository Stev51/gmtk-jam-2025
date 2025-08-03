extends Node

signal inv_select
signal inv_deselect

enum GameStates {RUNNING, PAUSED}

enum CursorStates {UNSELECTED, SELECTED}
enum PlacerStates {VALID, SOFT_INVALID, HARD_INVALID, OVERLAPPING}
enum MovableStates {NONE, CANPUSHNORTH, CANPUSHEAST, CANPUSHSOUTH, CANPUSHWEST, CANPULLNORTH, CANPULLEAST, CANPULLSOUTH, CANPULLWEST}

const DEFAULT_DIRECTION = Util.Direction.UP

var game_state = GameStates.RUNNING
