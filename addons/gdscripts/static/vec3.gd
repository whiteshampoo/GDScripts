class_name Vec3
## Useful methods to do stuff with [Vector3]


## Convenience method to produce [Vector2] from a [Vector3], discarding z.
## E.g. [code]vec3_to_vec2(Vector3(0.5, 1.0, 0.8))[/code] will return a [code]Vector2(0.5, 1.0)[/code]
static func to_vec2_xy(vector: Vector3) -> Vector2:
	return Vector2(vector.x, vector.y)


## Convenience method to produce [Vector2] from a [Vector3], discarding y.
## E.g. [code]vec3_to_vec2(Vector3(0.5, 1.0, 0.8))[/code] will return a [code]Vector2(0.5, 0.8)[/code]
static func to_vec2_xz(vector: Vector3) -> Vector2:
	return Vector2(vector.x, vector.z)


## Convenience method to produce [Vector2] from a [Vector3], discarding x.
## E.g. [code]vec3_to_vec2(Vector3(0.5, 1.0, 0.8))[/code] will return a [code]Vector2(1.0, 0.8)[/code]
static func to_vec2_yz(vector: Vector3) -> Vector2:
	return Vector2(vector.y, vector.z)


## Convenience method to reset the y value of a [Vector3] inline, optionally setting it to a specific value
## E.g. [code]Vec3.reset_x(Vector3(0.5, 42.0, 0.8))[/code] will return a [code]Vector3(0.0, 42.0, 0.8)[/code]
static func reset_x(vector: Vector3, x: float = 0.0) -> Vector3:
	return Vector3(x, vector.y, vector.z)


## Convenience method to reset the y value of a [Vector3] inline, optionally setting it to a specific value
## E.g. [code]vector.reset_y(Vector3(0.5, 42.0, 0.8))[/code] will return a [code]Vector3(0.5, 0.0, 0.8)[/code]
static func reset_y(vector: Vector3, y: float = 0.0) -> Vector3:
	return Vector3(vector.x, y, vector.z)


## Convenience method to reset the y value of a [Vector3] inline, optionally setting it to a specific value
## E.g. [code]vector.reset_z(Vector3(0.5, 42.0, 0.8))[/code] will return a [code]Vector3(0.5, 42.0, 0.0)[/code]
static func reset_z(vector: Vector3, z: float = 0.0) -> Vector3:
	return Vector3(vector.x, vector.y, z)
