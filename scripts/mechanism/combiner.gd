class_name Combiner extends Mechanism

const NODE = preload("res://scenes/combiner.tscn")

var dir: Util.Direction

func _init(field: Field, x: int, y:int, direction: Util.Direction):
	super(field, x, y, NODE.instantiate(), Field.BACKGROUND)
	dir = direction
	self.node.rotate(PI * dir / 2)

func update(currentCycle: int):
	self.node.play()
	var mechOnTop: Mechanism = field.getForegroundMechanism(x, y)
	if mechOnTop == null: return
	if !mechOnTop.connectMech(dir):
		field.deferBackgroundMechanismUpdate(getCoordinateVector())

func simulatePush(directionToMove: Util.Direction, pushType: PushType) -> bool:
	return false
