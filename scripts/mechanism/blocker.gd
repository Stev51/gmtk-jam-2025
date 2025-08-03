class_name Blocker extends Mechanism

const NODE = preload("res://scenes/blocker.tscn")
const ITEM = preload("res://inventory/items/blocker_item.tres")

const GROUND = Field.FOREGROUND

func _init(field: Field, x: int, y:int):
	super(field, x, y, NODE.instantiate(), GROUND, ITEM)

func simulatePush(directionToMove : Util.Direction, pushType : PushType) -> bool:
	if pushType != PushType.PLAYER: return false
	return super(directionToMove, pushType)
