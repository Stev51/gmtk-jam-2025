extends Node2D

func spawnInput(field: Field) -> void:
	field.addMechanism(Box.new(field, 1, 15))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
