class_name Painter extends Mechanism

const NODE = preload("res://scenes/painter.tscn")
const ITEM = preload("res://inventory/items/test_item.tres")

var color: Box.BoxColor = Box.BoxColor.PURPLE

func _init(field: Field, x: int, y:int, color: Box.BoxColor):
	super(field, x, y, NODE.instantiate(), Field.BACKGROUND, ITEM)
	setColor(color)

func setColor(color: Box.BoxColor):
	self.color = color
	self.node.frame = color

func update(currentCycle: int):
	var mech = field.getForegroundMechanism(x, y)
	if is_instance_of(mech, Box):
		mech.updateColor(color)

func simulatePush(directionToMove: Util.Direction, privilegedPush: bool = false) -> bool:
	return false
