class_name Blocker extends Mechanism

const NODE = preload("res://scenes/blocker.tscn")
const ITEM = preload("res://inventory/items/combiner_item.tres")

func _init(field: Field, x: int, y:int):
	super(field, x, y, NODE.instantiate(), Field.FOREGROUND, ITEM)

func simulatePush(directionToMove : Util.Direction, pushType : Mechanism.PushType) -> bool:
	return false
