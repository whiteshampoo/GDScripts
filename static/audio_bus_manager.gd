class_name AudioBusManager
## TODO: Documentation!

const MAX_VOLUME: float = 2.0

static var nonexisting_busses: Array[StringName]
static var bus_volume_callbacks: Dictionary
static var bus_mute_callbacks: Dictionary

static func bus_exists(bus: StringName) -> bool:
	return AudioServer.get_bus_index(bus) != -1


static func get_bus_index(bus: StringName) -> int:
	var bus_id: int = AudioServer.get_bus_index(bus)
	if bus_id == -1 and not bus in nonexisting_busses:
		push_warning("Audio-Bus '%s' does not exist!" % bus)
	return bus_id


static func _add_callback(dict: Dictionary, bus: StringName, callback: Callable) -> void:
	if not dict.has(bus):
		dict[bus] = [] as Array[Callable]
	if not callback in dict[bus]:
		@warning_ignore("unsafe_method_access") # FIXME in 4.4
		dict[bus].append(callback)


static func add_volume_callback(bus: StringName, callback: Callable) -> void:
	_add_callback(bus_volume_callbacks, bus, callback)


static func add_mute_callback(bus: StringName, callback: Callable) -> void:
	_add_callback(bus_mute_callbacks, bus, callback)


static func _remove_callback(dict: Dictionary, bus: StringName, callback: Callable) -> void:
	if not dict.has(bus):
		return
	@warning_ignore("unsafe_method_access") # FIXME in 4.4
	dict[bus].erase(callback)
	@warning_ignore("unsafe_method_access") # FIXME in 4.4
	if dict[bus].is_empty():
		dict.erase(bus)

static func remove_volume_callback(bus: StringName, callback: Callable) -> void:
	_remove_callback(bus_volume_callbacks, bus, callback)


static func remove_mute_callback(bus: StringName, callback: Callable) -> void:
	_remove_callback(bus_mute_callbacks, bus, callback)
	

static func _get_callbacks(dict: Dictionary, bus: StringName) -> Array:
	@warning_ignore("unsafe_method_access") # FIXME in 4.4
	for callback: Callable in dict.get(bus, []).duplicate():
		if not callback.is_valid():
			_remove_callback(dict, bus, callback)
	return dict.get(bus, [])


static func get_volume_callbacks(bus: StringName) -> Array[Callable]:
	return _get_callbacks(bus_volume_callbacks, bus)


static func get_mute_callbacks(bus: StringName) -> Array[Callable]:
	return _get_callbacks(bus_mute_callbacks, bus)


static func get_bus_volume(bus: StringName) -> float:
	var bus_id: int = get_bus_index(bus)
	if bus_id == -1:
		return 0.0
	return db_to_linear(AudioServer.get_bus_volume_db(bus_id))


static func set_bus_volume(bus: StringName, volume_linear: float) -> void:
	volume_linear = clampf(volume_linear, 0.0, MAX_VOLUME)
	
	var bus_id: int = get_bus_index(bus)
	if bus_id == -1:
		return
		
	var volume_db: float = linear_to_db(volume_linear)
	if is_equal_approx(volume_db, AudioServer.get_bus_volume_db(bus_id)):
		return
	AudioServer.set_bus_volume_db(bus_id, volume_db)
	for callback: Callable in get_volume_callbacks(bus):
		callback.call(volume_linear)


static func get_bus_mute(bus: StringName) -> bool:
	var bus_id: int = get_bus_index(bus)
	if bus_id == -1:
		return true
	return AudioServer.is_bus_mute(bus_id)


static func set_bus_mute(bus: StringName, mute: bool) -> void:
	var bus_id: int = get_bus_index(bus)
	if bus_id == -1:
		return
	if mute == AudioServer.is_bus_mute(bus_id):
		return
	AudioServer.set_bus_mute(bus_id, mute)
	
	for callback: Callable in get_mute_callbacks(bus):
		callback.call(mute)
