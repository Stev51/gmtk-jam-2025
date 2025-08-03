extends Node2D

enum CheckState {NONE, FAIL, SUCCEED}

var templateYOffset: int = 0

var currentSpawnPath = 1
var currentDifficulty = 0

var possibleOutputs: Array = Array()
var templateYOffsets: Array = Array()
var nextOutput: int
var curOutput: int

@onready var world_node = get_parent()

func spawnInput(field: Field) -> void:
	if currentSpawnPath == 1: 
		if field.getForegroundMechanism(1, 21) != null:
			Global.lose_game(world_node.totalBoxesOutput)
		field.addMechanism(Box.new(field, 1, 21))
	else: 
		if field.getForegroundMechanism(1, 25) != null:
			Global.lose_game(world_node.totalBoxesOutput)
		field.addMechanism(Box.new(field, 1, 25))
	currentSpawnPath *= -1

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

func clearOutput(field: Field) -> void:
	for x in 5:
		for y in 10:
			field.deleteMechanismAtPos(Field.NEXT_OUTPUT_POS + Vector2i(x, y - 2), Field.FOREGROUND)

func changeOutput(field: Field) -> void:
	currentDifficulty += 1
	clearOutput(field)
	curOutput = nextOutput
	curOutput = 4
	while nextOutput == curOutput: 
		var maxPosOutput = min(currentDifficulty + 3, possibleOutputs.size() - 1)
		var minPosOutput = max(currentDifficulty - 4, 0)
		nextOutput = (randi() % (1 + maxPosOutput - minPosOutput)) + minPosOutput
	
	templateYOffset = templateYOffsets[curOutput]
	possibleOutputs[curOutput].call(field, Field.NEXT_OUTPUT_POS.x, Field.NEXT_OUTPUT_POS.y + templateYOffset)
	possibleOutputs[nextOutput].call(field, Field.NEXT_OUTPUT_POS.x, Field.NEXT_OUTPUT_POS.y + 5 + templateYOffsets[nextOutput])

func generatePossibleOutputs(field: Field) -> void:
	nextOutput = 0
	# 2-stick
	possibleOutputs.append(func (field: Field, xOffset: int, yOffset: int):
		field.addMechanism(Box.new(field, xOffset, yOffset))
		field.addMechanism(Box.new(field, xOffset+1, yOffset))
		field.getForegroundMechanism(xOffset, yOffset).connectMech(Util.Direction.RIGHT)
	)
	templateYOffsets.append(0)
	
	# Rainbow 3-stick
	possibleOutputs.append(func (field: Field, xOffset: int, yOffset: int):
		field.addMechanism(Box.new(field, xOffset, yOffset, Box.BoxColor.RED))
		field.addMechanism(Box.new(field, xOffset+1, yOffset))
		field.addMechanism(Box.new(field, xOffset+2, yOffset, Box.BoxColor.BLUE))
		field.getForegroundMechanism(xOffset, yOffset).connectMech(Util.Direction.RIGHT)
		field.getForegroundMechanism(xOffset+1, yOffset).connectMech(Util.Direction.RIGHT)
	)
	templateYOffsets.append(0)
	
	# tromino-shape
	possibleOutputs.append(func (field: Field, xOffset: int, yOffset: int):
		field.addMechanism(Box.new(field, xOffset, yOffset))
		field.addMechanism(Box.new(field, xOffset+1, yOffset))
		field.addMechanism(Box.new(field, xOffset, yOffset-1))
		field.getForegroundMechanism(xOffset, yOffset).connectMech(Util.Direction.RIGHT)
		field.getForegroundMechanism(xOffset, yOffset).connectMech(Util.Direction.UP)
	)
	templateYOffsets.append(0)
	
	# 2x2 box
	possibleOutputs.append(func (field: Field, xOffset: int, yOffset: int):
		field.addMechanism(Box.new(field, xOffset, yOffset))
		field.addMechanism(Box.new(field, xOffset+1, yOffset))
		field.addMechanism(Box.new(field, xOffset, yOffset+1))
		field.addMechanism(Box.new(field, xOffset+1, yOffset+1))
		field.getForegroundMechanism(xOffset, yOffset).connectMech(Util.Direction.RIGHT)
		field.getForegroundMechanism(xOffset, yOffset).connectMech(Util.Direction.DOWN)
		field.getForegroundMechanism(xOffset+1, yOffset+1).connectMech(Util.Direction.UP)
		field.getForegroundMechanism(xOffset+1, yOffset+1).connectMech(Util.Direction.LEFT)
	)
	templateYOffsets.append(0)
	
	# 4-L shape
	possibleOutputs.append(func (field: Field, xOffset: int, yOffset: int):
		field.addMechanism(Box.new(field, xOffset, yOffset))
		field.addMechanism(Box.new(field, xOffset+1, yOffset))
		field.addMechanism(Box.new(field, xOffset+1, yOffset-1))
		field.addMechanism(Box.new(field, xOffset+1, yOffset-2))
		field.getForegroundMechanism(xOffset, yOffset).connectMech(Util.Direction.RIGHT)
		field.getForegroundMechanism(xOffset+1, yOffset).connectMech(Util.Direction.UP)
		field.getForegroundMechanism(xOffset+1, yOffset-1).connectMech(Util.Direction.UP)
	)
	templateYOffsets.append(0)
	
	# Red and blue stick
	possibleOutputs.append(func (field: Field, xOffset: int, yOffset: int):
		field.addMechanism(Box.new(field, xOffset, yOffset, Box.BoxColor.RED))
		field.addMechanism(Box.new(field, xOffset+1, yOffset, Box.BoxColor.RED))
		field.addMechanism(Box.new(field, xOffset, yOffset+1, Box.BoxColor.BLUE))
		field.addMechanism(Box.new(field, xOffset+1, yOffset+1, Box.BoxColor.BLUE))
		field.getForegroundMechanism(xOffset, yOffset).connectMech(Util.Direction.RIGHT)
		field.getForegroundMechanism(xOffset, yOffset).connectMech(Util.Direction.DOWN)
		field.getForegroundMechanism(xOffset+1, yOffset-1).connectMech(Util.Direction.LEFT)
	)
	templateYOffsets.append(0)
	
	# Ring
	possibleOutputs.append(func (field: Field, xOffset: int, yOffset: int):
		field.addMechanism(Box.new(field, xOffset, yOffset))
		field.addMechanism(Box.new(field, xOffset+1, yOffset))
		field.addMechanism(Box.new(field, xOffset, yOffset-1))
		field.addMechanism(Box.new(field, xOffset+1, yOffset-1))
		field.getForegroundMechanism(xOffset, yOffset).connectMech(Util.Direction.RIGHT)
		field.getForegroundMechanism(xOffset, yOffset).connectMech(Util.Direction.UP)
		field.getForegroundMechanism(xOffset+1, yOffset-1).connectMech(Util.Direction.DOWN)
		field.getForegroundMechanism(xOffset+1, yOffset-1).connectMech(Util.Direction.LEFT)
	)
	templateYOffsets.append(0)
