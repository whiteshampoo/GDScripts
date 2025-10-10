class_name AudioBusManager
## TODO: Documentation!


const MAX_VOLUME: float = 2.0
const VOLUME_SLIDER_GROUP: StringName = "VolumeSliders_%s"
const MUTE_BUTTON_GROUP: StringName = "MuteButtons_%s"

static var nonexisting_busses: Array[StringName]
static var renamed_busses: Array[StringName]


static func bus_exists(bus: StringName) -> bool:
	return AudioServer.get_bus_index(bus) != -1


static func get_index(bus: StringName) -> int:
	var bus_id: int = AudioServer.get_bus_index(bus)
	if bus_id == -1 and not bus in nonexisting_busses:
		nonexisting_busses.append(bus)
		var warning: String = "Audio-Bus '%s' does not exist!" % bus
		if bus in renamed_busses:
			warning += " (was renamed)"
		push_warning(warning)
	return bus_id


static func get_volume(bus: StringName) -> float:
	if not bus_exists(bus):
		return 0.0
	return db_to_linear(AudioServer.get_bus_volume_db(get_index(bus)))


static func set_volume(bus: StringName, volume_linear: float) -> void:
	if not bus_exists(bus):
		return
	
	volume_linear = clampf(volume_linear, 0.0, MAX_VOLUME)
	if is_equal_approx(volume_linear, get_volume(bus)):
		return
	
	AudioServer.set_bus_volume_db(get_index(bus), linear_to_db(volume_linear))
	_get_tree().call_group(VOLUME_SLIDER_GROUP % bus, "change_value", volume_linear)


static func get_mute(bus: StringName) -> bool:
	if not bus_exists(bus):
		return true
	return AudioServer.is_bus_mute(get_index(bus))


static func set_mute(bus: StringName, mute: bool) -> void:
	if not bus_exists(bus):
		return
	if mute == get_mute(bus):
		return
	AudioServer.set_bus_mute(get_index(bus), mute)
	_get_tree().call_group(MUTE_BUTTON_GROUP % bus, "change_button_pressed", mute)


static func register_node(node: Node) -> bool:
	var group: StringName = _choose_group(node)
	if group.is_empty():
		push_error("Only VolumeSlider and MuteButton is allowed.")
		return false
	var bus: StringName = node.get("bus")
	if not bus_exists(bus):
		return false
	if not AudioServer.bus_renamed.is_connected(_rename_groups):
		AudioServer.bus_renamed.connect(_rename_groups)
	node.add_to_group(group % bus)
	return true


static func _choose_group(node: Node) -> StringName:
	if node is VolumeSlider:
		return VOLUME_SLIDER_GROUP
	elif node is MuteButton:
		return MUTE_BUTTON_GROUP
	return ""


static func _rename_groups(_bus_index: int, old_name: StringName, new_name: StringName) -> void:
	_change_group_in_nodes(VOLUME_SLIDER_GROUP, old_name, new_name)
	_change_group_in_nodes(MUTE_BUTTON_GROUP, old_name, new_name)
	if new_name in nonexisting_busses:
		nonexisting_busses.erase(new_name)
	if not old_name in renamed_busses:
		renamed_busses.append(old_name)


static func _change_group_in_nodes(group_name: StringName, old_name: StringName, new_name: StringName) -> void:
	for node: Node in _get_tree().get_nodes_in_group(group_name % old_name):
		if not node is VolumeSlider and not node is MuteButton:
			continue
		node.remove_from_group(group_name % old_name)
		node.set("bus", new_name)
		node.add_to_group(group_name % new_name)


static func _get_tree() -> SceneTree:
	var tree: SceneTree = Engine.get_main_loop() as SceneTree
	if is_instance_valid(tree):
		return tree
	return SceneTree.new()
