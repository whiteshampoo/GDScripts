class_name LoadingScreen
extends ColorRect
## WIP
# TODO: Documentation & Refactoring!


static var texture: Texture2D = null
static var expand_mode: TextureRect.ExpandMode = TextureRect.ExpandMode.EXPAND_KEEP_SIZE
static var stretch_mode: TextureRect.StretchMode = TextureRect.StretchMode.STRETCH_KEEP_CENTERED

static var scene: String = ""

@onready var background: TextureRect = %Background
@onready var progress_bar: ProgressBar = %ProgressBar


func _ready() -> void:
	if ResourceLoader.has_cached(scene):
		background.hide()
		progress_bar.hide()
		#get_tree().change_scene_to_packed(ResourceLoader.get_cached_ref(scene)) # 4.4
		get_tree().change_scene_to_packed(ResourceLoader.load(scene))
	if is_instance_valid(texture):
		background.texture = texture
		background.expand_mode = expand_mode
		background.stretch_mode = stretch_mode


func _process(_delta: float) -> void:
	var progress: Array
	match ResourceLoader.load_threaded_get_status(scene, progress):
		ResourceLoader.ThreadLoadStatus.THREAD_LOAD_INVALID_RESOURCE:
			check_and_request_scene()
		ResourceLoader.ThreadLoadStatus.THREAD_LOAD_IN_PROGRESS:
			pass
		ResourceLoader.ThreadLoadStatus.THREAD_LOAD_FAILED:
			request_main_scene_after_failure()
		ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
			get_tree().change_scene_to_packed.call_deferred(ResourceLoader.load_threaded_get(scene))
	progress_bar.value = progress[0]


func get_main_scene_from_settings() -> String:
	var main_scene: String = ProjectSettings.get("application/run/main_scene")
	if not ResourceLoader.exists(main_scene, "PackedScene"):
		push_error("Cannot find main_scene '%s' from settings!" % main_scene)
		return ""
	return main_scene


func request_scene() -> bool:
	var error: Error = ResourceLoader.load_threaded_request(scene, "PackedScene")
	if error:
		push_error("Error while requesting scene '%s'. Quitting." % error_string(error))
		get_tree().quit()
		return false
	return true


func check_and_request_scene() -> bool:
	if not ResourceLoader.exists(scene, "PackedScene"):
		push_error("File '%s' does not exist! Trying to load main_scene from settings." % scene)
		scene = get_main_scene_from_settings()
	return request_scene()


func request_main_scene_after_failure() -> bool:
	if scene == get_main_scene_from_settings():
		push_error("Failed to load main_scene '%s'! Quitting." % scene)
		get_tree().quit()
		return false
	else:
		push_error("Failed to load scene '%s'! Trying to load main_scene from settings." % scene)
		scene = get_main_scene_from_settings()
	return request_scene()
	
