class_name Box extends Mechanism

const NODE = preload("res://scenes/box.tscn")

func _init(field: Field, x: int, y: int):
	super(field, x, y, NODE.instantiate())
