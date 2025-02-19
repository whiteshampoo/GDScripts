class_name MuteButton
extends Button
## TODO: Documentation!


@export var bus: StringName = "Master"


func _ready() -> void:
	toggle_mode = true
	if not AudioBusManager.register_node(self):
		return
	button_pressed = AudioBusManager.get_mute(bus)
	toggled.connect(_mute_changed)


func change_button_pressed(new_button_pressed: bool) -> void:
	toggled.disconnect(_mute_changed)
	button_pressed = new_button_pressed
	toggled.connect(_mute_changed)


func _mute_changed(new_mute: float) -> void:
	AudioBusManager.set_mute(bus, new_mute)
