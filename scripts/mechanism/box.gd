class_name Box extends Mechanism

enum BoxColor {PURPLE, RED, ORANGE, YELLOW, GREEN, BLUE}
#const boxColorAnimation = {
#	BoxColor.WHITE: "white",
#	BoxColor.RED: "red",
#	BoxColor.BLUE: "blue",
#	BoxColor.GREEN: "green",
#}

const NODE = preload("res://scenes/box.tscn")
const ITEM = preload("res://inventory/items/box_item.tres")

const GROUND = Field.FOREGROUND

var color: BoxColor

func _init(field: Field, x: int, y: int, color: BoxColor = BoxColor.PURPLE):
	super(field, x, y, NODE.instantiate(), GROUND, ITEM)
	field.deferBackgroundMechanismUpdate(Vector2i(x, y))
	self.color = color
	self.node.frame = color

func updateColor(color: BoxColor):
	self.color = color
	self.node.frame = color
