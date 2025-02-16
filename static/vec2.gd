class_name Vec2
## Useful methods to do stuff with Vector2


## Creates a random [Vector2]
static func random(min_length: float = 0.0, max_length: float = 1.0, min_angle: float = 0.0, max_angle: float = TAU) -> Vector2:
	return Vector2(randf_range(min_length, max_length), 0.0).rotated(randf_range(min_angle, max_angle))


## Creates a random, normalized (length == 1.0) [Vector2]
static func random_normalized(min_angle: float = 0.0, max_angle: float = TAU) -> Vector2:
	return Vector2.RIGHT.rotated(randf_range(min_angle, max_angle))


## Swaps the x- and y-value
static func swap(vector: Vector2) -> Vector2:
	return Vector2(vector.y, vector.x)


## Calculates the mean between the x- and y-value.
## [codeblock lang=gdscript]Vec2.value_mean(Vector2(0.5, 1.0)) # -> 0.75[/codeblock]
static func value_mean(vector: Vector2) -> float:
	return (vector.x + vector.y) / 2.0


## Calculates the lerp between the x- and y-value by weight.
## [codeblock lang=gdscript]Vec2.value_lerp(Vector2(-1.0, 1.0), 0.75) # -> 0.5[/codeblock]
static func value_lerp(vector: Vector2, weight: float) -> float:
	return lerp(vector.x, vector.y, weight)

## Directly converts a [Vector2] to [Vector3].
static func to_vec3_xy(vector: Vector2, z: float = 0.0) -> Vector3:
	return Vector3(vector.x, vector.y, z)


## Converts a [Vector2] to [Vector3] where the y-value becomes the z-value.
static func to_vec3_xz(vector: Vector2, y: float = 0.0) -> Vector3:
	return Vector3(vector.x, y, vector.y)