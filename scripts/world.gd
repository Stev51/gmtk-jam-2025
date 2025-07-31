class_name Field extends Node2D

enum {FOREGROUND, BACKGROUND}
var gameTime: int = 0
var map: Array = Array()

const SCALE: int = 64
const OFFSET: Vector2 = Vector2(SCALE / 2, SCALE / 2)
func _physics_process(delta):
	gameTime += 1
	if gameTime % (5*60) == 0:
		for x in map.size():
			for y in map[x].size():
				var object = map[x][y];
				if object != null:
					if object[FOREGROUND] != null:
						object[FOREGROUND].update()
					if object[BACKGROUND] != null:
						object[BACKGROUND].update()

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

func _enter_tree():
	map.resize(16)
	for x in 16:
		var column: Array = Array()
		column.resize(16)
		map[x] = column
	addMechanism(Box.new(self, 0, 0), FOREGROUND)
	addMechanism(Pusher.new(self, 0, 0, Util.Direction.RIGHT), BACKGROUND)
	addMechanism(Box.new(self, 1, 0), FOREGROUND)
	addMechanism(Box.new(self, 2, 0), FOREGROUND)
	addMechanism(Pusher.new(self, 3, 0, Util.Direction.DOWN), BACKGROUND)
	drawMap();

func addMechanism(mech: Mechanism, ground):
	if ground == BACKGROUND:
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
