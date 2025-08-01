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

# Variables to help with simulation
var processed: bool
var simulationResult: bool
var newPosition: Vector2i
var directionToMove: Util.Direction
var pushOverload: int # Counter for when more than one thing tries to push the box
var directPushByMech: bool # Flag for whether it is being directly pushed; makes push by pusher prioritize over push by block

func _init(field: Field, x: int, y:int, node: Node2D):
	self.field = field
	self.x = x
	self.y = y
	self.node = node
	self.node.translate(Field.SCALE * Vector2(x, y) + Field.OFFSET)
	
	#Set groups n such
	self.node.add_to_group("mechanisms")
	self.node.add_child(mek_selector_scene.instantiate())

# Initial attempt to push
# Used to determine what pushes what
# As some collision types are not yet be calculated, do not trust return value of true!
func simulatePush() -> bool:
	if processed: return simulationResult
	processed = true
	
	# To prevent recursive push calls, we temporarily set the result to fail
	simulationResult = false
	
	newPosition = Util.offset(Vector2i(x, y), directionToMove)
	var objectInWay: Mechanism = field.getForegroundVector(newPosition)
	
	# Check we are on the map
	if newPosition.x < 0 || newPosition.x >= Field.GRID_WIDTH || newPosition.y < 0 || newPosition.y >= Field.GRID_WIDTH: 
		simulationResult = false
		return false
	# Check if we can move into the next tile
	if objectInWay != null:
		# Check that we can change the movement direction, and then attempt the push
		if objectInWay.setToPush(directionToMove) && objectInWay.simulatePush():
			simulationResult = true
		else:
			simulationResult = false
	else:
		simulationResult = true
	return simulationResult

func setToPush(dir: Util.Direction) -> bool:
	if dir == directionToMove: return true
	if directPushByMech == true: return false
	pushOverload += 1
	if pushOverload > 1:
		simulationResult = false
		processed = true
		return false
	else: directionToMove = dir
	return true
	
func mechSetToPush(dir: Util.Direction) -> bool:
	directPushByMech = true
	if dir != directionToMove: pushOverload += 1
	if pushOverload > 1:
		simulationResult = false
		processed = true
		return false
	else: directionToMove = dir
	return true

# Note that we still have to perform checks
# since result may have changed since our simulation
# The propagation of these changes will *probably* not cause issues
func push() -> bool:
	if simulationResult == false: return false
	if directionToMove == Util.Direction.NONE: return false
	var offset: Vector2i = Util.offset(Vector2i(x, y), directionToMove)
	if offset.x < 0 || offset.x >= Field.GRID_WIDTH || offset.y < 0 || offset.y >= Field.GRID_WIDTH: return false
	var objectInWay: Mechanism = field.getForegroundVector(offset)
	if objectInWay != null:
		if (objectInWay.push()):
			field.setFutureForegroundVector(offset, self)
			field.setForegroundMechanism(self.x, self.y, null)
			self.x = offset.x
			self.y = offset.y
			self.node.translate(Util.offset(Vector2i(0, 0), directionToMove) * Field.SCALE)
			return true
		else:
			return false
	else:
		field.setFutureForegroundVector(offset, self)
		field.setForegroundMechanism(self.x, self.y, null)
		self.x = offset.x
		self.y = offset.y
		self.node.translate(Util.offset(Vector2i(0, 0), directionToMove) * Field.SCALE)
		return true

func update(currentCycle: int) -> void:
	pass

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
