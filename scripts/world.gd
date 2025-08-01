class_name Field extends Node2D

enum {FOREGROUND, BACKGROUND}
var currentCycle: int = 0
var map: Array = Array()

const GRID_WIDTH: int = 16
const GRID_HEIGHT: int = 16
const SCALE: int = 64
const OFFSET: Vector2 = Vector2(SCALE / 2, SCALE / 2)

var mechQueue: Array = Array()
var futureMechQueue: Array = Array()
var toRenderMechs: Array = Array()

func updateMechanisms() -> void:
	currentCycle += 1
	for mechPos in mechQueue:
		var mech: Mechanism = getBackgroundVector(mechPos)
		if mech != null: mech.update(currentCycle)

	mechQueue = futureMechQueue.duplicate()
	futureMechQueue.clear()

var tickProgress: float
func _process(delta: float):
	if toRenderMechs.is_empty():
		return
	tickProgress += delta * 2 # bigger numbers means the "frame" is processed faster (ie boxes move faster)
	var done: bool = false
	if (tickProgress >= 1):
		tickProgress = 1
		done = true
	for mech in toRenderMechs:
		mech.render(tickProgress)

	if done:
		toRenderMechs.clear()
		tickProgress = 0

func addToRenderQueue(mech: Mechanism):
	self.toRenderMechs.append(mech)

func deferBackgroundMechanismUpdate(pos: Vector2i):
	futureMechQueue.push_back(pos)

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
	#addMechanism(Pusher.new(self, 0, 0, Util.Direction.DOWN), BACKGROUND)
	addMechanism(Pusher.new(self, 1, 0, Util.Direction.RIGHT))
	addMechanism(Pusher.new(self, 2, 0, Util.Direction.RIGHT))
	addMechanism(Box.new(self, 1, 0))
	addMechanism(Box.new(self, 2, 0))
	addMechanism(Pusher.new(self, 3, 0, Util.Direction.DOWN))

	addMechanism(Box.new(self, 5, 0))
	addMechanism(Pusher.new(self, 5, 0, Util.Direction.RIGHT))
	addMechanism(Box.new(self, 8, 0))
	addMechanism(Box.new(self, 7, 0))
	addMechanism(Pusher.new(self, 8, 0, Util.Direction.LEFT))

	addMechanism(Painter.new(self, 7, 0, Box.BoxColor.YELLOW))

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

static func toSceneCoord(x: int, y: int) -> Vector2:
	return Vector2(x, y) * SCALE + OFFSET
