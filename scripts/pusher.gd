class_name Pusher extends Mechanism

const NODE = preload("res://scenes/pusher.tscn")

var dir: Util.Direction
var timing: int # Value in range 0-3

func _init(field: Field, x: int, y:int, direction: Util.Direction, timing: int = 0):
	super(field, x, y, NODE.instantiate())
	dir = direction
	self.node.rotate(PI * dir / 2)
	self.timing = timing

func update(currentCycle: int):
	if currentCycle % 4 != timing: return
	self.node.play()
	var object: Mechanism = field.getForegroundMechanism(self.x, self.y)
	if (object != null):
		object.setToPush(self.dir)

func simulatePush() -> bool:
	return false

func push() -> bool:
	return false
