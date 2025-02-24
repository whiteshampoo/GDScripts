class_name Autoload extends Node
## Class for defining saveable singletons (Autoloads).
## [member Autoload.default_data_path] is used to define which values are to be saved.
## [member Autoload.save_data] is used to store these values.[br][br]
## Call [code]super._ready()[/code] in a script extending this class to register the node in the SaveLoad singleton and you're done.


@onready var singleton: Node = get_node_or_null("/root/SaveLoad")

## Used to save data to disk and/or set default values.
## Required for registering in [SaveLoad].
var save_data: AutoloadData :
	get:
		return save_data
	set(val):
		save_data = val
		save_data.node = self

## Path used for saving [AutoloadData] to disk or loading it.
## Required for registering in [SaveLoad].
@onready var save_path: String = str("user://",name,"_data.tres")


func _ready()->void:
	if !singleton:
		return
	singleton.register_node(self)


## Returns the same data structure as [member Node.get_property_list] except it only contains exported properties. This is determined by the property's "usage" value being 4120.
func get_exports()->Array[Dictionary]:
	var property_list: Array[Dictionary] = get_property_list()
	var exports :Array[Dictionary]= []
	for property_data in property_list:
		if property_data.usage == 4102: # 4102 seems to be the property usage id for exports | dict.usage == PROPERTY_USAGE_SCRIPT_VARIABLE
			exports.append(property_data)
	return exports
