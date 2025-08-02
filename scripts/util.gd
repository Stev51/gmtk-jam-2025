class_name Util extends Object
enum Direction {RIGHT, DOWN, LEFT, UP}

static func offset(vect: Vector2i, dir: Direction) -> Vector2i:
	match dir:
		Direction.UP:
			return vect + Vector2i(0, -1)
		Direction.RIGHT:
			return vect + Vector2i(1, 0)
		Direction.DOWN:
			return vect + Vector2i(0, 1)
		Direction.LEFT:
			return vect + Vector2i(-1, 0)
		_:
			return vect

static func reverse(dir: Direction) -> Direction:
	match dir:
		Direction.UP:
			return Direction.DOWN
		Direction.DOWN:
			return Direction.UP
		Direction.LEFT:
			return Direction.RIGHT
		Direction.RIGHT:
			return Direction.LEFT
		_:
			return dir

static func rotate(dir: Direction) -> Direction:
	match dir:
		Direction.UP:
			return Direction.RIGHT
		Direction.RIGHT:
			return Direction.DOWN
		Direction.DOWN:
			return Direction.LEFT
		Direction.LEFT:
			return Direction.UP
		_:
			return dir

static func rotate_counterclockwise(dir: Direction) -> Direction:
	match dir:
		Direction.UP:
			return Direction.LEFT
		Direction.LEFT:
			return Direction.DOWN
		Direction.DOWN:
			return Direction.RIGHT
		Direction.RIGHT:
			return Direction.UP
		_:
			return dir
