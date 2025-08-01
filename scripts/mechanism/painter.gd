class_name Painter extends Mechanism

const NODE = preload("res://scenes/pusher.tscn")

func _init(field: Field, x: int, y:int):
	super(field, x, y, NODE.instantiate(), Field.BACKGROUND)
	
func update(currentCycle: int):
	var mech = field.getForegroundMechanism(x, y)
	if is_instance_of(mech, Box):
		mech.updateColor(Box.BoxColor.BLUE)
	
func push(directionToMove: Util.Direction) -> bool:
	return false
