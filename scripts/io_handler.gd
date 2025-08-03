extends Node2D

enum CheckState {NONE, FAIL, SUCCEED}

func spawnInput(field: Field) -> void:
	field.addMechanism(Box.new(field, 1, 21))

func checkOutput(field: Field) -> void:
	for x in 5:
		for y in 5: 
			var curCheck: CheckState = checkOnTile(field, Field.PLAYER_MAP_END.x + 4, 19+y)
			var currentMech: Mechanism = field.getForegroundMechanism(Field.PLAYER_MAP_END.x + 4, 19+y)
			if curCheck == CheckState.FAIL:
				field.resetSimulation()
				if currentMech.simulatePush(Util.Direction.UP, Mechanism.PushType.OUTPUT):
					currentMech.push(Util.Direction.UP)

# Doesn't really always work right for some weird output shapes
# but it probably doesn't matter
func checkOnTile(field: Field, x: int, y: int) -> CheckState:
	var mechOnTile: Mechanism = field.getForegroundMechanism(x, y)
	if mechOnTile == null:
		return CheckState.NONE
	if mechOnTile.connectedMechs[Util.Direction.UP] || mechOnTile.connectedMechs[Util.Direction.LEFT]:
		return CheckState.NONE
	if mechOnTile is Box:
		if mechOnTile.color == Box.BoxColor.RED: return CheckState.SUCCEED
		else: return CheckState.FAIL
	else:
		return CheckState.FAIL

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
