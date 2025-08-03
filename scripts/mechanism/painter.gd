class_name Painter extends Mechanism

const NODE = preload("res://scenes/painter.tscn")
const ITEM = preload("res://inventory/items/painter_item.tres")

const GROUND = Field.BACKGROUND

var color: Box.BoxColor = Box.BoxColor.PURPLE

func _init(field: Field, x: int, y:int, color: Box.BoxColor = Box.BoxColor.PURPLE):
	super(field, x, y, NODE.instantiate(), GROUND, ITEM)
	setColor(color)

func setColor(color: Box.BoxColor):
	self.color = color
	self.node.frame = color

func update(currentCycle: int):
	var mech = field.getForegroundMechanism(x, y)
	if is_instance_of(mech, Box):
		mech.updateColor(color)
