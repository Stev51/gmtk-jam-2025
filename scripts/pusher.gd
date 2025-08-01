class_name Pusher extends Mechanism

const NODE = preload("res://scenes/pusher.tscn")

var dir: Util.Direction

func _init(field: Field, x: int, y:int, direction: Util.Direction):
	super(field, x, y, NODE.instantiate())
	dir = direction
	self.node.rotate(PI * (dir + 3) / 2)

func update(currentCycle: int):
	self.node.play()
	var object: Mechanism = field.getForegroundMechanism(self.x, self.y)
	if (object != null):
		object.push(self.dir)

func push(directionToMove: Util.Direction) -> bool:
	return false
