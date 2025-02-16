class_name Arr
## Useful methods to do stuff with Arrays


## Returns a [Dictionary] with every value of the [Array] as key[br]
## and the return of [method Array.count] as value.
## [codeblock lang=GDScript]Arr.occurrences(["a", 1, "a", 1, 1])
## # -> {"a": 2, 1: 3}[/codeblock]
static func occurrences(array: Array) -> Dictionary:
	var dict: Dictionary
	for value: Variant in array:
		if value in dict:
			continue
		dict[value] = array.count(value)
	return dict


## Sorts the keys of the provided dict by the values and returns an array of the sorted keys.
## Expects a comparable type for the value of the dictionary, such as int or float.
## Ordering of keys with equal values may be random.
## Example: sort_keys_by_values({"a": 3, "b": 6, "c": 2, "d": 7}, false) will return ["d","b","a","c"]
static func sort_keys_by_values(dict: Dictionary, ascending: bool = true) -> Array:
	var keys: Array = dict.keys()
	keys.sort_custom(_sorter.bind(dict, ascending))
	return keys

## A sorter function that looks up the values to compare in the given dictionary.
## Expects a comparable type for the value of the dictionary, such as int or float.
static func _sorter(key1: Variant, key2: Variant, dict: Dictionary, ascending: bool) -> bool:
		return (dict[key1] < dict[key2]) == ascending
	
## Expects a Dictionary with float values, e.g. {"Sword": 1.5, "Trash": 3.0, "Treasure": 0.5}
## Returns a Dictionary[Variant, float] with normalized values, e.g. {"Sword": 0.3, "Trash": 0.6, "Treasure": 0.1}
static func normalize_values(dict: Dictionary) -> Dictionary:
	var sum: float = dict.values().reduce(func(i: float, accu:float) -> float: return accu + i)

	var normalized_dict: Dictionary = {}
	for key: Variant in dict.keys():
		normalized_dict[key] = dict[key]/sum
		
	return normalized_dict
