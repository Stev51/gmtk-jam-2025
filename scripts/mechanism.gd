extends Node2D
class_name Mechanism

@export var properties : TileEntityProperties
# Walls can be non-mechanisms with TileEntityproperties

# Old notes from Trent:
#Methods needed: detect player hands collision -> link incoming signals; push/pull signal -> move;
#detect box collision -> link outgoing signals; clock signal -> perform operation on linked object;
#hands uncollide -> unlink; box uncollide -> unlink

var field: Field
var x: int
var y: int
var node: Node2D

func _init(field: Field, x: int, y:int, node: Node2D):
	self.field = field
	self.x = x
	self.y = y
	self.node = node
	self.node.translate(Field.SCALE * Vector2(x, y) + Field.OFFSET)

# Initial attempt to push
# Used to determine what pushes what
# Some collision types will not yet be calculated!
func simulatePush(dir: Util.Direction) -> bool:
	var newPosition: Vector2i = Util.offset(Vector2i(x, y), dir)
	var objectInWay: Mechanism = field.getForegroundVector(newPosition)
	
	# Check we are on the map
	if newPosition.x < 0 || newPosition.x >= Field.GRID_WIDTH || newPosition.y < 0 || newPosition.y >= Field.GRID_WIDTH: return false
	return true
	
	

func push(dir: Util.Direction) -> bool:
	var offset: Vector2i = Util.offset(Vector2i(x, y), dir)
	#print("Attempt on box ", offset)
	var objectInWay: Mechanism = field.getForegroundVector(offset)
	if offset.x < 0 || offset.x >= Field.GRID_WIDTH || offset.y < 0 || offset.y >= Field.GRID_WIDTH: return false
	if objectInWay != null:
		if (objectInWay.push(dir)):
			field.setForegroundVector(offset, self)
			field.setForegroundMechanism(self.x, self.y, null)
			self.x = offset.x
			self.y = offset.y
			self.node.translate(Util.offset(Vector2i(0, 0), dir) * Field.SCALE)
			return true
		else:
			return false
	else:
		field.setForegroundVector(offset, self)
		field.setForegroundMechanism(self.x, self.y, null)
		self.x = offset.x
		self.y = offset.y
		self.node.translate(Util.offset(Vector2i(0, 0), dir) * Field.SCALE)
		return true

func update(currentCycle: int) -> void:
	pass

func getNode() -> Node2D:
	return node
# Consider moving anything to custom resources
# Walls and UI will be non-mechanisms, a different Node2D and Control respectively

#Properties needed: walkable; movable (pickup-able/shovable) (i.e. false for in/out conveyors);

#Methods needed: detect player hands collision -> link incoming signals; push/pull signal -> move;
#detect box collision -> link outgoing signals; clock signal -> perform operation on linked object;
#hands uncollide -> unlink; box uncollide -> unlink
