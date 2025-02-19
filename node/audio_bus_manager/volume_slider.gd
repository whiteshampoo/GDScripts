class_name VolumeSlider
extends Slider
## TODO: Documentation!


@export var bus: StringName = "Master"


func _ready() -> void:
	min_value = 0.0
	max_value = 1.0
	step = 0.01
	if not AudioBusManager.register_node(self):
		return
	value = AudioBusManager.get_volume(bus)
	value_changed.connect(_volume_changed)


func change_value(new_value: float) -> void:
	value_changed.disconnect(_volume_changed)
	value = new_value
	value_changed.connect(_volume_changed)


func _volume_changed(new_volume: float) -> void:
	AudioBusManager.set_volume(bus, new_volume)
