class_name VolumeSlider
extends Slider
## TODO: Documentation!

@export var bus: StringName = "Master"

func _ready() -> void:
	min_value = 0.0
	max_value = 1.0
	step = 0.01
	if not AudioBusManager.bus_exists(bus):
		push_warning("Audio-Bus '%s' does not exist!" % bus)
		return
	value = AudioBusManager.get_bus_volume(bus)
	AudioBusManager.add_volume_callback(bus, _volume_changed)
	tree_exiting.connect(AudioBusManager.remove_volume_callback.bind(bus, _volume_changed))
	value_changed.connect(_volume_changed)


func _volume_changed(new_volume: float) -> void:
	value = new_volume
	AudioBusManager.set_bus_volume(bus, new_volume)
