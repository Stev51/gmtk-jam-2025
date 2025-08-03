extends Node

signal pause_game
signal resume_game

signal inv_select
signal inv_deselect

enum GameStates {TITLE, RUNNING, PAUSED}

enum CursorStates {UNSELECTED, SELECTED}
enum PlacerStates {VALID, SOFT_INVALID, HARD_INVALID, OVERLAPPING}
enum MovableStates {NONE, CANPUSHNORTH, CANPUSHEAST, CANPUSHSOUTH, CANPUSHWEST, CANPULLNORTH, CANPULLEAST, CANPULLSOUTH, CANPULLWEST}

const DEFAULT_DIRECTION = Util.Direction.UP

var game_state = GameStates.TITLE

func _ready():
	pause_game.connect(pause)
	resume_game.connect(resume)

func pause():
	game_state = GameStates.PAUSED

func resume():
	game_state = GameStates.RUNNING
