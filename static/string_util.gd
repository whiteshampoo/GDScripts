class_name StringUtil extends Node

## Infers a name from the given variant and returns it as String
static func get_var_name(obj: Variant) -> String:
	if obj == null:
		return "null"
		#return "?"

	if obj is StringName:
		return (obj as StringName)
		
	if obj is String:
		return (obj as String)
		
	if obj is Node:
		return (obj as Node).name
		
	if obj is Object:
		var script: Variant = (obj as Object).get_script()
		if script != null:
			return (script as Script).get_global_name()
		
		return (obj as Object).get_class()

	return str(obj)
