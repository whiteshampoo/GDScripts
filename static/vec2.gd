class_name Vec2
## Useful methods to do stuff with Vector2


## Calculates the mean between the x- and y-value.
## [codeblock lang=gdscript]Vec2.value_mean(Vector2(0.5, 1.0)) # -> 0.75[/codeblock]
static func value_mean(vector: Vector2) -> float:
	return (vector.x + vector.y) / 2.0


## Calculates the lerp between the x- and y-value by weight.
## [codeblock lang=gdscript]Vec2.value_lerp(Vector2(-1.0, 1.0), 0.75) # -> 0.5[/codeblock]
static func value_lerp(vector: Vector2, weight) -> float:
	return lerp(vector.x, vector.y, weight)
