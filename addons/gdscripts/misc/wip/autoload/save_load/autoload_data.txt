class_name AutoloadData extends Resource
## Data storage class for game data saving implementation.


## Emitted when data was saved.
signal saved

## Emitted when data was loaded.
signal loaded


## Node that provides data for [Data] class
var node : Node


## Holds default values for creating a new [Data] object.
## Duplicating [member default_dict] into [member save_dict] and calling [method _load] allows resetting Autoload to default settings. 
var default_dict: Dictionary = {}

## Holds current save values. Key: StringName, Value: Variant
@export var save_dict: Dictionary = {}


## Saves current Autoload values to [member save_dict] dictionary. Returns self for saving to disk. Emits [signal saved] on finish.
func _save()->AutoloadData:
	for key: StringName in save_dict:
		if key in node:
			save_dict[key] = node.get(key)
	saved.emit()
	return self


## Loads values from [member save_dict] into Autoload. If Autoload does not have a variable, it will be ignored.
func _load()->AutoloadData:
	for key: StringName in save_dict:
		if key in node:
			node.set(key,save_dict[key])
	loaded.emit()
	return self


## Load values from [member AutoloadData.default_dict] into save_dict and then apply them to [member Autoload.node]
func reset_to_default()->void:
	save_dict = default_dict.duplicate(true)
	_load()


## [member AutoloadData.setup] is called by the SaveLoad singleton once to create a default_dict based on the export properties of a given node.
## Initially this default_dict is duplicated into [member AutoloadData.save_dict]. After the second launch data from save_dict is used instead of default values.
func setup(autoload:Autoload)->void:
	if !save_dict.is_empty():
		return
	for property_data: Dictionary in autoload.get_exports():
		default_dict[property_data.name] = autoload.get(property_data.name)
	save_dict = default_dict.duplicate(true)
