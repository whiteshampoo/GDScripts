class_name Vec2i
## Useful methods to do stuff with [Vector2i]

const ZERO: Array[Vector2i] = [Vector2i.ZERO]
const STRAIGHT: Array[Vector2i] = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]
const STRAIGHT_ZERO: Array[Vector2i] = STRAIGHT + ZERO
const DIAGONAL: Array[Vector2i] = [Vector2i(1, 1), Vector2i(-1, 1), Vector2i(1, -1), Vector2i(-1, -1)]
const DIAGONAL_ZERO: Array[Vector2i] = DIAGONAL + ZERO
const STAR: Array[Vector2i] = STRAIGHT + DIAGONAL
const STAR_ZERO: Array[Vector2i] = STAR + ZERO


## Creates a random [Vector2i]
static func random() -> Vector2i:
	return Vector2i(randi(), randi())


## Picks randomly from Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP and Vector2i.DOWN. Optionally with Vector2i.ZERO
static func random_straight(with_zero: bool = false) -> Vector2i:
	return (STRAIGHT_ZERO if with_zero else STRAIGHT).pick_random()


## Picks randomly from Vector2i(1, 1), Vector2i(-1, 1), Vector2i(1, -1), Vector2i(-1, -1). Optionally with Vector2i.ZERO
static func random_diagonal(with_zero: bool = false) -> Vector2:
	return (DIAGONAL_ZERO if with_zero else DIAGONAL).pick_random()


## Picks randomly from all 8 directions. Optionally with Vector2i.ZERO
static func random_direction(with_zero: bool = false) -> Vector2:
	return (STAR_ZERO if with_zero else STAR).pick_random()


## Swaps the x- and y-value
static func swap(vector: Vector2i) -> Vector2i:
	return Vector2(vector.y, vector.x)


## Directly converts a [Vector2] to [Vector3].
static func to_vec3i_xy(vector: Vector2i, z: int = 0) -> Vector3i:
	return Vector3i(vector.x, vector.y, z)


## Converts a [Vector2] to [Vector3] where the y-value becomes the z-value.
static func to_vec3i_xz(vector: Vector2i, y: int = 0) -> Vector3i:
	return Vector3i(vector.x, y, vector.y)
