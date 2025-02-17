class_name MuteButton
extends Button
## TODO: Documentation!

@export var bus: StringName = "Master"

func _ready() -> void:
	toggle_mode = true
	if not AudioBusManager.bus_exists(bus):
		push_warning("Audio-Bus '%s' does not exist!" % bus)
		return
	button_pressed = AudioBusManager.get_bus_mute(bus)
	AudioBusManager.add_mute_callback(bus, _mute_changed)
	tree_exiting.connect(AudioBusManager.remove_mute_callback.bind(bus, _mute_changed))
	toggled.connect(_mute_changed)


func _mute_changed(new_mute: float) -> void:
	button_pressed = new_mute
	AudioBusManager.set_bus_mute(bus, new_mute)
