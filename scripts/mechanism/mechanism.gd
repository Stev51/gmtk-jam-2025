extends Node2D
class_name Mechanism

@export var properties : TileEntityProperties
# Walls can be non-mechanisms with TileEntityproperties

var mek_selector_scene = preload("res://scenes/mechanism_selector_area.tscn")

var field: Field
var x: int
var y: int
var oldPos: Vector2
var newPos: Vector2
var node: Node2D
var ground: int
var item: InventoryItem
var queuePosition: Field.QueuePos
const CONNECTOR = preload("res://scenes/connector.tscn")
# Stores whether connected to boxes in each of the cardinal directions
var connectedMechs: Array[bool] = [false, false, false, false]
var connectorNodes: Array[Node] = [null, null, null, null]

# Used when simulating pushes
var simulationResult: bool
var processed: bool = false
# Used to determine if the connected block has already been pushed
var pushed: bool = false
# PLAYER type is usually ignored but can be read by child classes
enum PushType {INPUT, NORMAL, PLAYER, OUTPUT}

func _init(field: Field, x: int, y:int, node: Node2D, ground: int, item: InventoryItem, queuePosition: Field.QueuePos = Field.QueuePos.PRE):
	self.field = field
	self.x = x
	self.y = y
	self.node = node
	self.ground = ground
	self.item = item
	self.queuePosition = queuePosition
	self.node.position = Field.toSceneCoord(x, y)

	if ground == Field.FOREGROUND:
		self.node.add_to_group("FOREGROUND")
	elif ground == Field.BACKGROUND:
		self.node.add_to_group("BACKGROUND")
	else:
		push_error("Background type not recognized for Mechanism")
	#Set groups n such
	self.node.add_to_group("mechanisms")
	self.node.add_child(mek_selector_scene.instantiate())

func simulatePush(directionToMove: Util.Direction, pushType: PushType) -> bool:
	if processed: return simulationResult
	processed = true
	# If we've already been pushed in the tick, can't get pushed again
	if pushed:
		simulationResult = false
		return simulationResult
	# If we're not in the play area and the attempt is not privileged, then stop
	if (pushType == PushType.NORMAL || pushType == PushType.PLAYER) && !field.inPlayerMap(getCoordinateVector()):
		simulationResult = false
		return simulationResult
	# If something tries to refer back to this mid simulation,
	# we assume that this would succeed
	simulationResult = true
	
	var newPosition: Vector2i = Util.offset(Vector2i(x, y), directionToMove)
	if newPosition.x < 0 || newPosition.x >= Field.GRID_WIDTH || newPosition.y < 0 || newPosition.y >= Field.GRID_HEIGHT:
		simulationResult = false
		return simulationResult
	if (pushType == PushType.NORMAL || pushType == PushType.PLAYER) && !field.inPlayerMap(newPosition):
		simulationResult = false
		return simulationResult
	if pushType == PushType.INPUT && newPosition.x > Field.PLAYER_MAP_END.x:
		simulationResult = false
		return simulationResult
	var objectInWay: Mechanism = field.getMechanismVector(newPosition, ground)
	if objectInWay != null && !objectInWay.simulatePush(directionToMove, pushType):
		simulationResult = false
		return simulationResult

	for dir in Util.Direction.size():
		# We've already propagated simulation in the direction we're moving
		# so don't do that again
		if dir == directionToMove || !connectedMechs[dir]: continue

		var adjPosition: Vector2i = Util.offset(Vector2i(x, y), dir)
		if adjPosition.x < 0 || adjPosition.x >= Field.GRID_WIDTH || adjPosition.y < 0 || adjPosition.y >= Field.GRID_HEIGHT: continue

		var adjMech: Mechanism = field.getMechanismVector(adjPosition, ground)
		if !adjMech.simulatePush(directionToMove, pushType):
			simulationResult = false
			return simulationResult

	simulationResult = true
	return simulationResult

# Should only be run if simulation succeeds
func push(directionToMove: Util.Direction) -> void:
	if pushed: return
	pushed = true
	var newPosition: Vector2i = Util.offset(Vector2i(x, y), directionToMove)
	var objectInWay: Mechanism = field.getMechanismVector(newPosition, ground)
	if objectInWay != null:
		objectInWay.push(directionToMove)

	field.setMechanismVector(newPosition, self, ground)
	field.setMechanism(self.x, self.y, null, ground)
	if ground == Field.FOREGROUND: field.deferBackgroundMechanismUpdate(newPosition)
	self.oldPos = Field.toSceneCoord(self.x, self.y)
	self.x = newPosition.x
	self.y = newPosition.y
	self.newPos = Field.toSceneCoord(self.x, self.y)
	field.addToRenderQueue(self)

	for dir in Util.Direction.size():
		# We've already propagated simulation in the direction we're moving
		# so don't do that again
		if dir == directionToMove || !connectedMechs[dir]: continue
		# Find position adjacent to where we used to be
		var adjPosition: Vector2i = Util.offset(Util.offset(Vector2i(x, y), dir), Util.reverse(directionToMove))
		if adjPosition.x < 0 || adjPosition.x >= Field.GRID_WIDTH || adjPosition.y < 0 || adjPosition.y >= Field.GRID_HEIGHT: continue
		var adjMech: Mechanism = field.getMechanismVector(adjPosition, ground)
		if adjMech != null: adjMech.push(directionToMove)

func playerPush(directionToMove: Util.Direction) -> void:
	field.resetSimulation()
	if simulatePush(directionToMove, PushType.PLAYER):
		push(directionToMove)

func updateMechConnection(newState: bool, dir: Util.Direction) -> bool:
	if connectedMechs[dir] == newState: return true
	var mechToConnect: Mechanism = field.getForegroundVector(Util.offset(Vector2i(x, y), dir))
	if mechToConnect != null:
		connectedMechs[dir] = newState
		if (newState):
			var connector: Node = CONNECTOR.instantiate()
			connector.rotate(PI * dir / 2)
			self.node.add_child(connector)
			self.connectorNodes[dir] = connector
		else:
			self.connectorNodes[dir].queue_free()
		mechToConnect.updateMechConnection(newState, Util.reverse(dir))
		return true
	else:
		return false

func connectMech(dir: Util.Direction) -> bool:
	return updateMechConnection(true, dir)

func disconnectMech(dir: Util.Direction) -> bool:
	return updateMechConnection(false, dir)

func update(currentCycle: int) -> void:
	pass

func render(delta: float) -> void:
	self.node.position = self.oldPos.lerp(self.newPos, delta)

func getNode() -> Node2D:
	return node

func getCoordinateVector() -> Vector2i:
	return Vector2i(x, y)
# Consider moving anything to custom resources
