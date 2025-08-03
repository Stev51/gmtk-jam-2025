class_name Field extends Node2D

enum {FOREGROUND, BACKGROUND}
enum QueuePos {PRE, POST}
var currentCycle: int = 0
var map: Array = Array()

const GRID_WIDTH: int = 32
const GRID_HEIGHT: int = 32
const SCALE: int = 64
const TILE_OFFSET: Vector2i = Vector2i(-10, -10)
const OFFSET: Vector2 = Vector2(SCALE*TILE_OFFSET.x + (SCALE / 2), SCALE*TILE_OFFSET.y + (SCALE / 2))

const PLAYER_MAP_START = Vector2i(10, 10)
const PLAYER_MAP_END = Vector2i(19, 19)

var mechQueue: Array = Array()
var futureMechQueue: Array = Array()
var toRenderMechs: Array = Array()

@onready var main_tile_map_layer = $MainTileMapLayer

func updateMechanisms() -> void:
	# Reset push state of all boxes
	for x in map:
		for object in x:
			if (object != null):
				if object[FOREGROUND] != null:
					object[FOREGROUND].pushed = false
				if object[BACKGROUND] != null:
					object[BACKGROUND].pushed = false

	currentCycle += 1
	if (currentCycle % 10 == 0):
		$IOHandler.spawnInput(self)
	for y in 5: deleteMechanismAtPos(Vector2i(25, 13 + y), FOREGROUND)

	if currentCycle % 2 == 0:
		for mechPos in mechQueue:
			var mech: Mechanism = getBackgroundVector(mechPos)
			if mech != null && mech.queuePosition == QueuePos.PRE:
				mech.update(currentCycle)
	else:
		for mechPos in mechQueue:
			var mech: Mechanism = getBackgroundVector(mechPos)
			if mech != null && mech.queuePosition == QueuePos.POST:
				mech.update(currentCycle)
		mechQueue = futureMechQueue
		futureMechQueue = Array()

# Resets simulation state for all components on the grid.
# Used to determine whether a push can successfully occur
func resetSimulation() -> void:
	for x in map:
		for object in x:
			if (object != null):
				if object[FOREGROUND] != null:
					object[FOREGROUND].processed = false

func inPlayerMap(pos: Vector2i) -> bool:
	return (pos.x >= PLAYER_MAP_START.x && pos.x <= PLAYER_MAP_END.x
			&& pos.y >= PLAYER_MAP_START.y && pos.y <= PLAYER_MAP_END.y)

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
		if mech != null: mech.render(tickProgress)

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

func getMechanism(x: int, y: int, ground: int) -> Mechanism:
	if ground == FOREGROUND: return getForegroundMechanism(x, y)
	else: return getBackgroundMechanism(x, y)

func getMechanismVector(pos: Vector2i, ground: int) -> Mechanism:
	if ground == FOREGROUND: return getForegroundMechanism(pos.x, pos.y)
	else: return getBackgroundMechanism(pos.x, pos.y)

func setMechanism(x: int, y: int, mech: Mechanism, ground: int):
	if ground == FOREGROUND: setForegroundMechanism(x, y, mech)
	else: setBackgroundMechanism(x, y, mech)

func setMechanismVector(pos: Vector2i, mech: Mechanism, ground: int):
	if ground == FOREGROUND: setForegroundMechanism(pos.x, pos.y, mech)
	else: setBackgroundMechanism(pos.x, pos.y, mech)

func _ready():
	map.resize(GRID_WIDTH)
	for x in GRID_WIDTH:
		var column: Array = Array()
		column.resize(GRID_HEIGHT)
		map[x] = column

	for x in 10: addMechanism(Pusher.new(self, x, 15, Util.Direction.RIGHT, Mechanism.PushType.INPUT))
	for x in 10: addMechanism(Pusher.new(self, x + 19, 15, Util.Direction.RIGHT, Mechanism.PushType.OUTPUT))

	$MechanismClock.start()

func addMechanism(mech: Mechanism):
	if mech.ground == BACKGROUND:
		self.setBackgroundMechanism(mech.x, mech.y, mech)
	else:
		self.setForegroundMechanism(mech.x, mech.y, mech)
	self.add_child(mech.getNode())
	mech.onCreation()

func deleteMechanismAtPos(pos: Vector2i, ground: int):
	var container = map[pos.x][pos.y]
	if container == null: return
	var object = container[ground]
	if object == null: return

	var mech = getMechanismVector(pos, ground)
	if mech:
		mech.onRemove()
		mech.queue_free()
	setMechanismVector(pos, null, ground)

func deleteMechanism(mech: Mechanism):
	for x in map.size():
		for y in map[x].size():
			var object = map[x][y]
			if object != null:
				if object[FOREGROUND] == mech:
					setForegroundMechanism(x, y, null)
				if object[BACKGROUND] == mech:
					setBackgroundMechanism(x, y, null)

	if mech:
		mech.onRemove()
		mech.queue_free()


func _on_mechanism_clock_timeout() -> void:
	updateMechanisms()

static func toSceneCoord(x: int, y: int) -> Vector2:
	return Vector2(x, y) * SCALE + OFFSET

func get_mech_from_node(node):
	if node == null:
		return	null
	var node_pos = main_tile_map_layer.local_to_map(node.position) - TILE_OFFSET

	if node.is_in_group("FOREGROUND"):
		return getForegroundMechanism(node_pos.x, node_pos.y)
	elif node.is_in_group("BACKGROUND"):
		return getBackgroundMechanism(node_pos.x, node_pos.y)
	else:
		return null
