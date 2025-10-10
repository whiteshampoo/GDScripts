class_name ChangeSceneButtonLoader
extends Button
## A selfmanaging [Button] to change the main-scene with background loading and loading-screen
## requires [LoadingScreen]
## WIP

@export_file("*.tscn", "*.scn") var scene: String = ""
@export_file("*.tscn", "*.scn") var loading_screen: String = ""
@export var load_in_background: bool = false
@export var cache_mode: ResourceLoader.CacheMode = ResourceLoader.CacheMode.CACHE_MODE_REUSE
@export var use_sub_threads: bool = false


func _ready() -> void:
	if not ResourceLoader.exists(scene):
		push_warning("File '%s' does not exist" % scene)
		return
	if load_in_background:
		var error: Error = ResourceLoader.load_threaded_request(
			scene,
			"PackedScene",
			use_sub_threads,
			cache_mode)
		if error:
			push_error("Error while requesting '%s': %s" % [scene, error_string(error)])


func _pressed() -> void:
	if not ResourceLoader.exists(scene):
		push_error("File '%s' does not exist" % scene)
		return
	LoadingScreen.scene = scene
	get_tree().change_scene_to_file(loading_screen) # FIXME: testing if this is a valid file
