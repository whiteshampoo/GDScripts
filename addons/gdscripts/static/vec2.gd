class_name Vec2
## Useful methods to do stuff with Vector2


## Creates a random [Vector2]
static func random(min_length: float = 0.0, max_length: float = 1.0, min_angle: float = 0.0, max_angle: float = TAU) -> Vector2:
	return Vector2.from_angle(randf_range(min_angle, max_angle)) * randf_range(min_length, max_length)


## Creates a random, normalized (length == 1.0) [Vector2]
static func random_normalized(min_angle: float = 0.0, max_angle: float = TAU) -> Vector2:
	return Vector2.from_angle(randf_range(min_angle, max_angle))


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
	return lerpf(vector.x, vector.y, weight)

## Directly converts a [Vector2] to [Vector3].
static func to_vec3_xy(vector: Vector2, z: float = 0.0) -> Vector3:
	return Vector3(vector.x, vector.y, z)


## Converts a [Vector2] to [Vector3] where the y-value becomes the z-value.
static func to_vec3_xz(vector: Vector2, y: float = 0.0) -> Vector3:
	return Vector3(vector.x, y, vector.y)


## Sorts a given array of vectors by distance to [code]origin[/code]. Use [code]closest_first[/code] to define the order in which the arrays are returned.
static func sort_vectors_by_distance(vector_array: Array[Vector2], origin: Vector2, closest_first: bool = true)->Array[Vector2]:
	var sorted_array: Array[Vector2] = vector_array.duplicate()
	if closest_first:
		sorted_array.sort_custom(_sort_closer.bind(origin))
	else:
		sorted_array.sort_custom(_sort_further.bind(origin))
	return sorted_array


## Used by [member sort_vectors_by_distance]
static func _sort_closer(a: Vector2, b: Vector2, origin: Vector2)->bool:
	# The function should return true if the first element should be moved behind the second one, otherwise it should return false.
	return a.distance_squared_to(origin) < b.distance_squared_to(origin)


## Used by [member sort_vectors_by_distance]
static func _sort_further(a: Vector2, b: Vector2, origin: Vector2)->bool:
	# The function should return true if the first element should be moved behind the second one, otherwise it should return false.
	return a.distance_squared_to(origin) > b.distance_squared_to(origin)

	
## Convenience method to produce [Vector2] from a [Vector3], discarding y.
## E.g. [code]vec3_to_vec2(Vector3(0.5, 1.0, 0.8))[/code] will return a [code]Vector2(0.5, 0.8)[/code]
static func from_vec3_xz(vec3: Vector3) -> Vector2:
	return Vector2(vec3.x, vec3.z);


#TODO: rename this class to a more generic Vector class, or move to a new Vec3 util class?
## Convenience method to reset the y value of a vector3 inline, optionally setting it to a specific value
## E.g. [code]vec3_reset_y(Vector3(0.5, 42.0, 0.8))[/code] will return a [code]Vector3(0.5, 0.0, 0.8)[/code]
static func vec3_reset_y(vec3: Vector3, y: float = 0.0) -> Vector3:
	return Vector3(vec3.x, y, vec3.z);
