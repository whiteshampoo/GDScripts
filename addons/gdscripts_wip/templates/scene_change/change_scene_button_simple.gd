class_name ChangeSceneButtonSimple
extends Button
## A self-managing [Button] to change the main-scene


@export_file("*.tscn", "*.scn") var scene: String = ""


func _ready() -> void:
	if not ResourceLoader.exists(scene, "PackedScene"):
		push_warning("File '%s' does not exist" % scene)


func _pressed() -> void:
	if not ResourceLoader.exists(scene, "PackedScene"):
		push_error("File '%s' does not exist" % scene)
		return
	get_tree().change_scene_to_file(scene)
