class_name Box extends Mechanism

enum BoxColor {WHITE, RED, BLUE, GREEN}

const NODE = preload("res://scenes/box.tscn")

var color = BoxColor.WHITE

func _init(field: Field, x: int, y: int):
	super(field, x, y, NODE.instantiate())
	field.deferBackgroundMechanismUpdate(Vector2i(x, y))
	
func push(directionToMove: Util.Direction) -> bool:
	self.updateColor(Box.BoxColor.RED)
	return super.push(directionToMove)

func updateColor(color: BoxColor):
	self.color = color
	
