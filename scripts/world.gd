class_name Field extends Node2D

enum {FOREGROUND, BACKGROUND}
var currentCycle: int = 0
var map: Array = Array()

const GRID_WIDTH: int = 16
const GRID_HEIGHT: int = 16
const SCALE: int = 64
const OFFSET: Vector2 = Vector2(SCALE / 2, SCALE / 2)

# For usage in simulation
var futureMap: Array = Array()
func updateMechanisms() -> void:
	# Clear old simulation results
	for x in map.size():
		for y in map[x].size():
			var holder = map[x][y]
			if holder != null:
				var object = holder[FOREGROUND]
				if object != null:
					object.processed = false
					object.directionToMove = Util.Direction.NONE
					object.pushOverload = 0
					object.directPushByMech = false
	futureMap.resize(GRID_WIDTH)
	for x in GRID_WIDTH:
		var column: Array = Array()
		column.resize(GRID_HEIGHT)
		futureMap[x] = column
	
	# Propagate updates in new cycle
	currentCycle += 1
	for x in map.size():
		for y in map[x].size():
			var object = map[x][y];
			if object != null:
				if object[FOREGROUND] != null:
					object[FOREGROUND].update(currentCycle)
				if object[BACKGROUND] != null:
					object[BACKGROUND].update(currentCycle)
	
	# Simulate movement
	for x in map.size():
		for y in map[x].size():
			var holder = map[x][y]
			if holder != null:
				var object = holder[FOREGROUND]
				if object != null && object.directionToMove != Util.Direction.NONE:
					object.simulatePush()
	
	# Check if two objects are trying to move to the same position
	var newMap: Array = Array()
	newMap.resize(GRID_WIDTH)
	for x in GRID_WIDTH:
		var column: Array = Array()
		column.resize(GRID_HEIGHT)
		newMap[x] = column
		for y in GRID_HEIGHT:
			newMap[x][y] = Array()
	
	for x in map.size():
		for y in map[x].size():
			var holder = map[x][y]
			if holder != null:
				var object = map[x][y][FOREGROUND]
				if object != null && object.simulationResult == true:
					newMap[object.newPosition.x][object.newPosition.y].append(object)
	
	for x in newMap.size():
		for y in newMap[x].size():
			if newMap[x][y].size() > 1:
				for object in newMap[x][y]:
					object.simulationResult = false
	
	# Process new cycle changes
	for x in map.size():
		for y in map[x].size():
			var holder = map[x][y]
			if holder != null:
				var object = map[x][y][FOREGROUND]
				if object != null:
					object.push()
	
	for x in map.size():
		for y in map[x].size():
			if futureMap[x][y] != null:
				setForegroundMechanism(x, y, futureMap[x][y])


func setFutureForegroundMechanism(x: int, y: int, mech: Mechanism):
	futureMap[x][y] = mech
	
func setFutureForegroundVector(pos: Vector2i, mech: Mechanism):
	setFutureForegroundMechanism(pos.x, pos.y, mech)

func getForegroundMechanism(x: int, y: int) -> Mechanism:
	var mechs = map[x][y]
	if mechs != null:
		return mechs[FOREGROUND]
	else:
		return null

func setForegroundMechanism(x: int, y: int, mech: Mechanism):
	var mechs = map[x][y]
	if mechs == null:
		mechs = [null, null]
		map[x][y] = mechs
	mechs[FOREGROUND] = mech

func getForegroundVector(pos: Vector2i) -> Mechanism:
	return getForegroundMechanism(pos.x, pos.y)

func setForegroundVector(pos: Vector2i, mech: Mechanism) -> Mechanism:
	return setForegroundMechanism(pos.x, pos.y, mech)

func getBackgroundMechanism(x: int, y: int) -> Mechanism:
	var mechs = map[x][y]
	if mechs != null:
		return mechs[BACKGROUND]
	else:
		return null

func setBackgroundMechanism(x: int, y: int, mech: Mechanism):
	var mechs = map[x][y]
	if mechs == null:
		mechs = [null, null]
		map[x][y] = mechs
	mechs[BACKGROUND] = mech

func getBackgroundVector(pos: Vector2i) -> Mechanism:
	return getBackgroundMechanism(pos.x, pos.y)

func setBackgroundVector(pos: Vector2i, mech: Mechanism) -> Mechanism:
	return setBackgroundMechanism(pos.x, pos.y, mech)

func _ready():
	map.resize(GRID_WIDTH)
	for x in GRID_WIDTH:
		var column: Array = Array()
		column.resize(GRID_HEIGHT)
		map[x] = column
	#addMechanism(Box.new(self, 0, 0), FOREGROUND)
	#addMechanism(Pusher.new(self, 0, 0, Util.Direction.DOWN, 1), BACKGROUND)
	addMechanism(Pusher.new(self, 1, 0, Util.Direction.RIGHT, 1), BACKGROUND)
	addMechanism(Pusher.new(self, 2, 0, Util.Direction.RIGHT, 1), BACKGROUND)
	addMechanism(Box.new(self, 1, 0), FOREGROUND)
	addMechanism(Box.new(self, 2, 0), FOREGROUND)
	addMechanism(Pusher.new(self, 3, 0, Util.Direction.DOWN, 1), BACKGROUND)
	
	#addMechanism(Box.new(self, 5, 0), FOREGROUND)
	#addMechanism(Pusher.new(self, 5, 0, Util.Direction.RIGHT, 1), BACKGROUND)
	#addMechanism(Box.new(self, 8, 0), FOREGROUND)
	#addMechanism(Box.new(self, 7, 0), FOREGROUND)
	#addMechanism(Pusher.new(self, 8, 0, Util.Direction.LEFT, 1), BACKGROUND)
	
	#addMechanism(Box.new(self, 3, 3), FOREGROUND)
	#addMechanism(Box.new(self, 4, 3), FOREGROUND)
	#addMechanism(Box.new(self, 5, 3), FOREGROUND)
	#addMechanism(Pusher.new(self, 3, 3, Util.Direction.DOWN), BACKGROUND)
	
	drawMap()
	
	$MechanismClock.start()

func addMechanism(mech: Mechanism):
	if mech.ground == BACKGROUND:
		self.setBackgroundMechanism(mech.x, mech.y, mech)
	else:
		self.setForegroundMechanism(mech.x, mech.y, mech)

func drawMap():
	for x in map.size():
		for y in map[x].size():
			var mech: Mechanism = getForegroundMechanism(x, y)
			if mech != null:
				self.add_child(mech.getNode())
			mech = getBackgroundMechanism(x, y)
			if mech != null:
				self.add_child(mech.getNode())


func _on_mechanism_clock_timeout() -> void:
	updateMechanisms()
