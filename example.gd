extends Node

# This is a test-scene and may have random content

func _ready() -> void:
	print(Vec2.value_mean(Vector2.RIGHT))
	print(Vec2.value_lerp(Vector2(-1.0, 1.0), 0.75))
