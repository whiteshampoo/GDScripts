class_name RandomUtil extends Object

## Returns a Vector2 with a random direction.
static func random_direction() -> Vector2:
	var angle : float = random_angle()
	return Vector2.from_angle(angle)

## Returns a random angle in radians.
static func random_angle() -> float:
	return randf() * PI * 2
	
## Expects a [code]Dictionary[Variant, float][/code]. Chooses a random key, depending on the probabilities provided as values. 
## If the [code]probabilities[/code] is already normalized, you can set [code]is_normalized[/code] to true.
## Example: for [code]pick_key_by_probabilities({ "Sword": 1.5, "Trash": 3.0, "Treasure": 0.5 })[/code], this will have a
## - 30% probability to return [code]"Sword"[/code],[br] 
## - 60% probability to return [code]"Trash"[/code],[br]
## - 10% probability to return [code]"Treasure"[/code].[br]
## May return [code]null[/code] if the dictionary is empty or not normalized.
static func pick_key_by_probabilities(probabilities: Dictionary, is_normalized: bool = false) -> Variant:
	var probabilities_to_use: Dictionary = probabilities if is_normalized else Dict.normalize_values(probabilities)
	var rand_value: float = randf()
	var accu_sum: float = 0;
	for key: Variant in probabilities_to_use.keys():
		accu_sum = accu_sum + probabilities_to_use[key]
		if rand_value < accu_sum:
			return key
		
	return null
