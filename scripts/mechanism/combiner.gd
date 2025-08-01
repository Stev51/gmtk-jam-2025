class_name Combiner extends Mechanism

const NODE = preload("res://scenes/painter.tscn")

var dir: Util.Direction

func _init(field: Field, x: int, y:int, direction: Util.Direction):
	super(field, x, y, NODE.instantiate(), Field.BACKGROUND)
	dir = direction
	self.node.rotate(PI * dir / 2)

func update(currentCycle: int):
	pass

func simulatePush(directionToMove: Util.Direction) -> bool:
	return false
