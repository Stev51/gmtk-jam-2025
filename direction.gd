class_name Util extends Object
enum Direction {UP, RIGHT, DOWN, LEFT}

static func offset(vect: Vector2i, dir: Direction) -> Vector2i:
	match dir:
		Direction.UP:
			return vect + Vector2i(0, -1)
		_.RIGHT:
			return vect + Vector2i(1, 0)
		DOWN:
			return vect + Vector2i(0, 1)
		LEFT:
			return vect + Vector2i(-1, 0)
		_:
			return vect
