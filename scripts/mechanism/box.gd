class_name Box extends Mechanism

enum BoxColor {PURPLE, RED, ORANGE, YELLOW, GREEN, BLUE}
#const boxColorAnimation = {
#	BoxColor.WHITE: "white",
#	BoxColor.RED: "red",
#	BoxColor.BLUE: "blue",
#	BoxColor.GREEN: "green",
#}

const NODE = preload("res://scenes/box.tscn")

var color = BoxColor.PURPLE

func _init(field: Field, x: int, y: int):
	super(field, x, y, NODE.instantiate(), Field.FOREGROUND)
	field.deferBackgroundMechanismUpdate(Vector2i(x, y))

func push(directionToMove: Util.Direction) -> bool:
	return super.push(directionToMove)

func updateColor(color: BoxColor):
	self.color = color
	self.node.frame = color
