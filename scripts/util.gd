class_name Util extends Object
enum Direction {RIGHT, DOWN, LEFT, UP, NONE}

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
