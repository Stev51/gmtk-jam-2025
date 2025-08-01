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

func _init(field: Field, x: int, y:int, node: Node2D, ground: int):
	self.field = field
	self.x = x
	self.y = y
	self.ground = ground
	self.node = node
	self.node.translate(Field.SCALE * Vector2(x, y) + Field.OFFSET)
	
	#Set groups n such
	self.node.add_to_group("mechanisms")
	self.node.add_child(mek_selector_scene.instantiate())

func push(directionToMove: Util.Direction) -> bool:
	if directionToMove == Util.Direction.NONE: return false
	var newPosition: Vector2i = Util.offset(Vector2i(x, y), directionToMove)
	if newPosition.x < 0 || newPosition.x >= Field.GRID_WIDTH || newPosition.y < 0 || newPosition.y >= Field.GRID_WIDTH: return false
	var objectInWay: Mechanism = field.getForegroundVector(newPosition)
	if objectInWay != null:
		if (objectInWay.push(directionToMove)):
			field.setForegroundVector(newPosition, self)
			field.setForegroundMechanism(self.x, self.y, null)
			field.deferBackgroundMechanismUpdate(newPosition)
			self.x = newPosition.x
			self.y = newPosition.y
			self.node.translate(Util.offset(Vector2i(0, 0), directionToMove) * Field.SCALE)
			return true
		else:
			return false
	else:
		field.setForegroundVector(newPosition, self)
		field.setForegroundMechanism(self.x, self.y, null)
		field.deferBackgroundMechanismUpdate(newPosition)
		self.x = newPosition.x
		self.y = newPosition.y
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
