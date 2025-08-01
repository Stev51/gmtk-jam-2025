class_name Pusher extends Mechanism

const NODE = preload("res://scenes/pusher.tscn")

var dir: Util.Direction
var privileged: Mechanism.PushType

func _init(field: Field, x: int, y:int, direction: Util.Direction, privileged: Mechanism.PushType = Mechanism.PushType.NORMAL):
	super(field, x, y, NODE.instantiate(), Field.BACKGROUND, Field.QueuePos.POST)
	dir = direction
	self.node.rotate(PI * dir / 2)
	self.privileged = privileged

func update(currentCycle: int):
	var object: Mechanism = field.getForegroundMechanism(self.x, self.y)
	if (object != null):
		field.resetSimulation()
		if object.simulatePush(self.dir, privileged): 
			self.node.play()
			object.push(self.dir)
		else: field.deferBackgroundMechanismUpdate(getCoordinateVector())

func simulatePush(directionToMove: Util.Direction, pushType: PushType) -> bool:
	return false
