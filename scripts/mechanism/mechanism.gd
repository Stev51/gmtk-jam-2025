extends Node2D
class_name Mechanism

@export var properties : TileEntityProperties
# Walls can be non-mechanisms with TileEntityproperties

# Old notes from Trent:
#Methods needed: detect player hands collision -> link incoming signals; push/pull signal -> move;
#detect box collision -> link outgoing signals; clock signal -> perform operation on linked object;
#hands uncollide -> unlink; box uncollide -> unlink

var mek_selector_scene = preload("res://scenes/mechanism_selector_area.tscn")

var field: Field
var x: int
var y: int
var node: Node2D
var ground: int
var queuePosition: Field.QueuePos
# Stores whether connected to boxes in each of the cardinal directions
var connectedMechs: Array[bool] = [false, false, false, false]

# Used when simulating pushes
var simulationResult: bool
var processed: bool = false
# Used to determine if the connected block has already been pushed
var pushed: bool = false

var oldPos: Vector2
var newPos: Vector2

func _init(field: Field, x: int, y:int, node: Node2D, ground: int, queuePosition: Field.QueuePos = Field.QueuePos.PRE):
	self.field = field
	self.x = x
	self.y = y
	self.node = node
	self.ground = ground
	self.queuePosition = queuePosition
	self.node.position = Field.toSceneCoord(x, y)

	if ground == Field.FOREGROUND:
		self.node.add_to_group("FOREGROUND")
	elif ground == Field.BACKGROUND:
		self.node.add_to_group("BACKGROUND")
	else:
		push_error("Background type not recognized for Mekanism")
	#Set groups n such
	self.node.add_to_group("mechanisms")
	self.node.add_child(mek_selector_scene.instantiate())

func simulatePush(directionToMove: Util.Direction) -> bool:
	if processed: return simulationResult
	processed = true
	# If we've already been pushed in the tick, can't get pushed again
	if pushed:
		simulationResult = false
		return simulationResult
	# If something tries to refer back to this mid simulation,
	# we assume that this would succeed
	simulationResult = true
	var newPosition: Vector2i = Util.offset(Vector2i(x, y), directionToMove)
	if newPosition.x < 0 || newPosition.x >= Field.GRID_WIDTH || newPosition.y < 0 || newPosition.y >= Field.GRID_WIDTH: return false
	var objectInWay: Mechanism = field.getForegroundVector(newPosition)
	
	if objectInWay != null && !objectInWay.simulatePush(directionToMove):
		simulationResult = false
		return simulationResult
	
	for dir in Util.Direction.size():
		# We've already propagated simulation in the direction we're moving
		# so don't do that again
		if dir == directionToMove || !connectedMechs[dir]: continue
		var adjPosition: Vector2i = Util.offset(Vector2i(x, y), dir)
		if adjPosition.x < 0 || adjPosition.x >= Field.GRID_WIDTH || adjPosition.y < 0 || adjPosition.y >= Field.GRID_WIDTH: continue
		var adjMech: Mechanism = field.getForegroundVector(adjPosition)
		if !adjMech.simulatePush(directionToMove):
			simulationResult = false
			return simulationResult
	
	simulationResult = true
	return simulationResult

# Should only be run if simulation succeeds
func push(directionToMove: Util.Direction) -> void:
	if pushed: return
	pushed = true
	var newPosition: Vector2i = Util.offset(Vector2i(x, y), directionToMove)
	var objectInWay: Mechanism = field.getForegroundVector(newPosition)
	if objectInWay != null:
		objectInWay.push(directionToMove)
		
	field.setForegroundVector(newPosition, self)
	field.setForegroundMechanism(self.x, self.y, null)
	field.deferBackgroundMechanismUpdate(newPosition)
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
		if adjPosition.x < 0 || adjPosition.x >= Field.GRID_WIDTH || adjPosition.y < 0 || adjPosition.y >= Field.GRID_WIDTH: continue
		var adjMech: Mechanism = field.getForegroundVector(adjPosition)
		if adjMech != null: adjMech.push(directionToMove)

func updateMechConnection(newState: bool, dir: Util.Direction) -> bool:
	if connectedMechs[dir] == newState: return true
	var mechToConnect: Mechanism = field.getForegroundVector(Util.offset(Vector2i(x, y), dir))
	if mechToConnect != null:
		connectedMechs[dir] = newState
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
# Walls and UI will be non-mechanisms, a different Node2D and Control respectively

#Properties needed: walkable; movable (pickup-able/shovable) (i.e. false for in/out conveyors);

#Methods needed: detect player hands collision -> link incoming signals; push/pull signal -> move;
#detect box collision -> link outgoing signals; clock signal -> perform operation on linked object;
#hands uncollide -> unlink; box uncollide -> unlink
