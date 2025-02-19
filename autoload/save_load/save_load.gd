## SaveLoad singleton
## Dependencies: Autoload, AutoloadData
extends Node
## This script is meant to be a simple saving & loading implementation that can easily be dropped into any project.[br][br]
## To use it, simply use [member register_node] on any node of which you want to save/load data to/from disk.[br]
## Although this script is meant to be used with the Autoload class, the functions in the SaveLoad singletons can be made to work with any Node.
## Just make sure to supply the right data structure. See [member _is_valid_node]

## Can be used to print debug messages to a custom function. If left unchanged, simply prints to console.
var logging_function: Callable = Callable(print_log)

## Set to false to deactivate saving to disk.
var saving_enabled : bool = true

## Array should not be appended/set directly. Use [member register_node] for node validation. 
var _registered_nodes : Array

## Emitted when node has been registered and data object initiated/loaded.
signal node_registered


func _ready()->void:
	# Disable auto accepting quit requests so that we can save the game when it quits.
	get_tree().set_auto_accept_quit(false)


## Default logging function. Replace using [member set_logging_function].
func print_log(string:String)->void:
	print(get_tree().get_frame(),": ",string)


## This can be used to supply a function with which to output info supplied by this object. The method of the callable given to this function should take a string as its first argument.
func set_logging_function(callable: Callable)->void:
	logging_function = callable


## Register Node for automatic savefile loading/saving.
func register_node(node:Node)->Object:
	if !_is_valid_node(node):
		var msg: String = str("[",name,"] Node does not have the correct data structure: ",node) 
		push_warning(msg)
		logging_function.call(msg)
		return
	_registered_nodes.append(node)
	_initiate_node(node)
	logging_function.call(str("[",name,"] '",node.name, "' registered in SaveLoad"))
	return self

## If there is a save file for the node being initiated, load the data from that save file. Otherwise create a new save file.
func _initiate_node(node:Node)->void:
	if !load_from_disk(node):
		_new_data_file(node)
		var status_msg: String = str("[",name,"] Creating new save_data file from node's default properties")
		logging_function.call(status_msg)
	node_registered.emit()

## Check if node fits the pattern of [Autoload] data structure.
func _is_valid_node(node:Node)->bool:
	if not "save_data" in node:
		return false
	if not "save_path" in node:
		return false
	return true


## Saves all nodes in [member _registered_nodes].
func save_registered_nodes()->void:
	if !_registered_nodes.is_empty():
		for node: Node in _registered_nodes:
			save_to_disk(node)
			var msg: String = str("[",name,"] '",node.name,"' saved")
			logging_function.call(msg)


## Saves [Data] to disk using [member save_path].
func save_to_disk(node:Node)->bool:
	if node.save_data.has_method("_save"):
		node.save_data._save()
	var Error := ResourceSaver.save(node.save_data,node.save_path)
	if Error != OK:
		push_warning("[",name,"] Something went wrong saving settings to disk")
	return true


## Loads [SettingsData] from disk using [member save_path]. Returns false if file isn't found or loading fails.
func load_from_disk(node:Node)->bool:
	var status_msg: String
	if !ResourceLoader.exists(node.save_path):
		status_msg = str("[",name,"] No file found in path ", node.save_path)
		logging_function.call(status_msg)
		return false
	
	var save_data := ResourceLoader.load(node.save_path)
	# TODO: maybe add is_valid_save_data function to avoid enforcing usage of AutoloadData.
	if not save_data is AutoloadData:
		status_msg = str("[",name,"] Invalid save file - not of type Data: ",node.save_path)
		push_warning(status_msg)
		logging_function.call(status_msg)
		return false
	status_msg = str("[",name,"] Loading save_data for '", node.name,"' from '",node.save_path,"'")
	logging_function.call(status_msg)
	node.save_data = save_data
	if node.save_data.has_method("_load"):
		node.save_data._load()
	else:
		status_msg = str("[",name,"] Something went wrong loading resource '", node.save_path,"'. Could not find '_load' function")
		push_warning(status_msg)
		logging_function.call(status_msg)
		return false
	return true

## Creates a new [AutoloadData] and loads its default values into its node via _load().
func _new_data_file(node:Node)->void:
	node.save_data = AutoloadData.new()
	node.save_data.setup(node)


## Save on Exit
func _notification(what: int)->void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		_save_and_exit()

## Automatically save the registered nodes unless saving is disabled.
func _save_and_exit()->void:
	var status_msg: String
	if saving_enabled:
		status_msg = str("[",name,"] Saving...")
		logging_function.call(status_msg)
		save_registered_nodes()
	status_msg = str("[",name,"] Closing window")
	logging_function.call(status_msg)
	await get_tree().create_timer(0.1).timeout
	get_tree().quit()


## Just a helper function to close the application.
func request_quit()->void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
