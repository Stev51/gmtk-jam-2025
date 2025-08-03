class_name Blocker extends Mechanism

const NODE = preload("res://scenes/blocker.tscn")
const ITEM = preload("res://inventory/items/blocker_item.tres")

const GROUND = Field.FOREGROUND

func _init(field: Field, x: int, y:int):
	super(field, x, y, NODE.instantiate(), GROUND, ITEM)

func onCreation():
	for i in 8:
		var mech = self.field.getForegroundMechanism(self.x + xs[i], self.y + ys[i])
		if mech is Blocker:
			mech.updateConnectedTextures()
	updateConnectedTextures()

func onRemove():
	super()
	for i in 8:
		var mech = self.field.getForegroundMechanism(self.x + xs[i], self.y + ys[i])
		if mech is Blocker:
			mech.updateConnectedTextures()

func simulatePush(directionToMove : Util.Direction, pushType : PushType) -> bool:
	if pushType != PushType.PLAYER: return false
	return super(directionToMove, pushType)

const xs = [0, 1, 1, 1, 0, -1, -1, -1]
const ys = [-1, -1, 0, 1, 1, 1, 0, -1]

# yes this is awful, but I don't care
# any complaints must be submitted alongside a patch fixing it
func updateConnectedTextures():
	# up, right, down, left
	var cardinals = Array()
	cardinals.resize(4)
	cardinals[0] = self.field.getForegroundMechanism(self.x, self.y - 1) is Blocker
	# up-right, down-right, down-left, up-left
	var corners = Array()
	corners.resize(4)
	for j in range(2, 8, 2):
		var x = xs[j]
		var y = ys[j]
		cardinals[j / 2] = self.field.getForegroundMechanism(self.x + x, self.y + y) is Blocker
		if cardinals[j / 2] && cardinals[j / 2 - 1]:
			corners[j / 2 - 1] = self.field.getForegroundMechanism(self.x + xs[j - 1], self.y + ys[j - 1]) is Blocker
		else:
			corners[j / 2 - 1] = false
	if cardinals[3] && cardinals[0]:
		corners[3] = self.field.getForegroundMechanism(self.x + xs[7], self.y + ys[7]) is Blocker
	else:
		corners[3] = false

	var cardCount: int = 0
	for cardinal in cardinals:
		if cardinal:
			cardCount += 1
	var cornerCount: int = 0
	for corner in corners:
		if corner:
			cornerCount += 1
	var overlay: Sprite2D = self.node.get_node("Sprite2D/Overlay")
	if cardCount == 0:
		overlay.frame = 0
	elif cardCount == 1:
		overlay.frame = 4
		if cardinals[0]:
			overlay.rotation = 1 * PI / 2
		elif cardinals[1]:
			overlay.rotation = 2 * PI / 2
		elif cardinals[2]:
			overlay.rotation = 3 * PI / 2
		elif cardinals[3]:
			overlay.rotation = 0 * PI / 2
	elif cardCount == 2:
		overlay.frame = 14
		if cardinals[0] && cardinals[2]:
			overlay.rotation = 1 * PI / 2
		elif cardinals[1] && cardinals[3]:
			overlay.rotation = 0 * PI / 2
		else:
			if cardinals[0] && cardinals[1]:
				overlay.rotation = 2 * PI / 2
			elif cardinals[1] && cardinals[2]:
				overlay.rotation = 3 * PI / 2
			elif cardinals[2] && cardinals[3]:
				overlay.rotation = 0 * PI / 2
			elif cardinals[3] && cardinals[0]:
				overlay.rotation = 1 * PI / 2
			if cornerCount == 0:
				overlay.frame = 10
			elif cornerCount == 1:
				overlay.frame = 8
	elif cardCount == 3:
		if !cardinals[0]:
			overlay.rotation = 3 * PI / 2
		elif !cardinals[1]:
			overlay.rotation = 0 * PI / 2
		elif !cardinals[2]:
			overlay.rotation = 1 * PI / 2
		elif !cardinals[3]:
			overlay.rotation = 2 * PI / 2
		if cornerCount == 0:
			overlay.frame = 2
		elif cornerCount == 1:
			if corners[0]:
				if cardinals[2]:
					overlay.frame = 6
				else:
					overlay.frame = 11
			elif corners[1]:
				if cardinals[3]:
					overlay.frame = 6
				else:
					overlay.frame = 11
			elif corners[2]:
				if cardinals[0]:
					overlay.frame = 6
				else:
					overlay.frame = 11
			elif corners[3]:
				if cardinals[1]:
					overlay.frame = 6
				else:
					overlay.frame = 11
		elif cornerCount == 2:
			overlay.frame = 12
	elif cardCount == 4:
		if cornerCount == 0:
			overlay.frame = 1
			overlay.rotation = 0 * PI / 2
		elif cornerCount == 1:
			overlay.frame = 5
			if corners[0]:
				overlay.rotation = 2 * PI / 2
			elif corners[1]:
				overlay.rotation = 3 * PI / 2
			elif corners[2]:
				overlay.rotation = 0 * PI / 2
			elif corners[3]:
				overlay.rotation = 1 * PI / 2
		elif cornerCount == 2:
			overlay.frame = 7
			if corners[0] && corners[2]:
				overlay.rotation = 2 * PI / 2
			elif corners[1] && corners[3]:
				overlay.rotation = 1 * PI / 2
			else:
				overlay.frame = 9
				if corners[0] && corners[1]:
					overlay.rotation = 2 * PI / 2
				elif corners[1] && corners[2]:
					overlay.rotation = 3 * PI / 2
				elif corners[2] && corners[3]:
					overlay.rotation = 0 * PI / 2
				elif corners[3] && corners[0]:
					overlay.rotation = 1 * PI / 2
		elif cornerCount == 3:
			overlay.frame = 13
			if !corners[0]:
				overlay.rotation = 3 * PI / 2
			elif !corners[1]:
				overlay.rotation = 0 * PI / 2
			elif !corners[2]:
				overlay.rotation = 1 * PI / 2
			elif !corners[3]:
				overlay.rotation = 2 * PI / 2
		elif cornerCount == 4:
			overlay.frame = 15
			overlay.rotation = 0
