class_name Painter extends Mechanism

const NODE = preload("res://scenes/pusher.tscn")

func _init(field: Field, x: int, y:int):
	super(field, x, y, NODE.instantiate(), Field.FOREGROUND)
	
func update(currentCycle: int):
	pass
	
func push(directionToMove: Util.Direction) -> bool:
	return false
