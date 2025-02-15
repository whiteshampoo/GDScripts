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

## Appends a value to an array if the array does not yet contain the value.
static func append_distinct(arr: Array, val: Variant) -> Array:
	if arr.has(val):
		return arr
	arr.append(val)
	return arr
