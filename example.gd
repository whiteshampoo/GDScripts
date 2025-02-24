extends Node

var CLASS_COLOR: Color = Color.html("bef3e2")
var FUNC_COLOR: Color = Color.html("57b2ff")
var ARGS_COLOR: Color = Color.html("fceb9f")
var TRANSITION_COLOR: Color = Color.LIGHT_CYAN
var RESULT_COLOR: Color = Color.html("f989c7")

# This is a test-scene and may have random content

func test_callback(volume: float) -> void:
	print("new value: ", volume)

func _ready() -> void:
	return

	@warning_ignore("unreachable_code")
	demo_function(Vec2.value_mean.bind(Vector2.RIGHT), "Vec2")
	demo_function(Vec2.value_lerp.bind(Vector2(-1.0, 1.0), 0.75), "Vec2")

	demo_function(Arr.occurrences.bind([1, 2, 3, 2, 2, 4, 4, 4]), "Arr")
	#demo_function(Arr.sort_keys_by_values.bind({"a": 3, "b": 6, "c": 2, "d": 7}, false), "Arr")
	#demo_function(Arr.normalize_values.bind({"Sword": 1.5, "Trash": 3.0, "Treasure": 0.5}), "Arr")

	demo_function(RandomUtil.random_angle, "RandomUtil")
	demo_function(RandomUtil.random_direction, "RandomUtil")
	demo_function(RandomUtil.pick_key_by_probabilities.bind({ "Sword": 0.3, "Trash": 0.6, "Treasure": 0.1 }, true), "RandomUtil")

	demo_function(StringUtil.get_var_name.bind(self), "StringUtil")
	
	demo_function(NodeUtil.collect_nodes_in_children.bind(get_tree().root, is_base_button), "NodeUtil")
	
	var buttons: Array[CanvasItem]
	buttons.assign(NodeUtil.collect_nodes_in_children(self, is_base_button))
	demo_function(NodeUtil.set_visible_only.bind(buttons[0], buttons as Array[CanvasItem]), "NodeUtil")

	demo_function(TimeUtil.timestamp.bind(true), "TimeUtil")

func demo_function(f: Callable, static_class_name: String) -> void:
	var args: String = ", ".join(f.get_bound_arguments().map(as_string))
	args = with_rich_color(args, ARGS_COLOR)
	var called_obj: String = with_rich_color(static_class_name, CLASS_COLOR)
	var called_function: String = with_rich_color("." + f.get_method() + "("+ args + ")", FUNC_COLOR)
	var call_name: String = called_obj + called_function
	var result: String = with_rich_color(as_string(f.call()), RESULT_COLOR)
	print_rich(call_name + with_rich_color("   --->   ", TRANSITION_COLOR) + result)

func with_rich_color(text: String, color: Color) -> String:
	return "[color=\""+color.to_html()+"\"]" + text + "[/color]"
	
func as_string(obj: Variant) -> String:
	if obj == null:
		return "void"
	return ("\"" + obj + "\"") if obj is String else str(obj)

static func is_base_button(node: Node) -> bool:
	return node is BaseButton
