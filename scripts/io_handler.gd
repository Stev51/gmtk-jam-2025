extends Node2D

enum CheckState {NONE, FAIL, SUCCEED}

var templateYOffset: int = 0

func spawnInput(field: Field) -> void:
	field.addMechanism(Box.new(field, 1, 21))

func checkOutput(field: Field) -> void:
	for x in 5:
		for y in 5: 
			var curCheck: CheckState = checkOnTile(field, Field.PLAYER_MAP_END.x + 4 + x, 19+y)
			var currentMech: Mechanism = field.getForegroundMechanism(Field.PLAYER_MAP_END.x + 4 + x, 19+y)
			if curCheck == CheckState.FAIL:
				field.resetSimulation()
				if currentMech.simulatePush(Util.Direction.UP, Mechanism.PushType.OUTPUT):
					currentMech.push(Util.Direction.UP)
			elif curCheck == CheckState.SUCCEED:
				field.resetSimulation()
				if currentMech.simulatePush(Util.Direction.RIGHT, Mechanism.PushType.OUTPUT):
					currentMech.push(Util.Direction.RIGHT)

# Doesn't really always work right for some weird output shapes
# but it probably doesn't matter
func checkOnTile(field: Field, x: int, y: int) -> CheckState:
	var mechOnTile: Mechanism = field.getForegroundMechanism(x, y)
	if mechOnTile == null:
		return CheckState.NONE
	if mechOnTile.connectedMechs[Util.Direction.UP] || mechOnTile.connectedMechs[Util.Direction.LEFT]:
		return CheckState.NONE
	
	for posX in 5:
		for posY in 5:
			var templateMech = field.getForegroundVector(Field.NEXT_OUTPUT_POS + Vector2i(posX, posY + templateYOffset))
			var outputMech = field.getForegroundMechanism(x + posX, y + posY)
			if templateMech == null:
				continue
			if outputMech == null:
				return CheckState.FAIL
			# this
			if templateMech is Box && outputMech is Box:
				if templateMech.color != outputMech.color:
					return CheckState.FAIL
				for dir in Util.Direction.size():
					if templateMech.connectedMechs[dir] != outputMech.connectedMechs[dir]:
						return CheckState.FAIL
			else:
				push_error("templateMech or outputMech not a Box")
	return CheckState.SUCCEED

func setOutput(field: Field) -> void:
	field.addMechanism(Box.new(field, Field.NEXT_OUTPUT_POS.x, Field.NEXT_OUTPUT_POS.y))
	field.addMechanism(Box.new(field, Field.NEXT_OUTPUT_POS.x+1, Field.NEXT_OUTPUT_POS.y))
	field.getForegroundMechanism(Field.NEXT_OUTPUT_POS.x, Field.NEXT_OUTPUT_POS.y).connectMech(Util.Direction.RIGHT)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
