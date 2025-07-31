class_name Pusher extends Mechanism

const NODE = preload("res://scenes/pusher.tscn")

var dir: Util.Direction

func _init(field: Field, x: int, y:int, direction: Util.Direction):
	super(field, x, y, NODE.instantiate())
	dir = direction
	self.node.rotate(3.1415926 * dir / 2)

func update():
	self.node.play()
	var object: Mechanism = field.getForegroundMechanism(self.x, self.y)
	if (object != null):
		object.push(self.dir)

func push(dir: Util.Direction) -> bool:
	return false
