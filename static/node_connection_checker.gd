class_name NodeConnectionChecker


## Info object for a single signal connection
class ConnectionInfo:
	var is_marked: bool
	var connection_name: String 

## Info object for a node, containing the connection info for a single signal.
class NodeInfo:
	var node_path: String
	var connection_info: Array[ConnectionInfo]

## Collects the a [code]NodeInfo[/code] array based on all nodes below the given root node for a given signal. 
## For this, [method NodeUtil.collect_nodes_in_children] will be used.
## The marker function is a Callable (ConnectionInfo) -> bool. This is used to mark specific connections.
## The filter function is a Callable (Node) -> bool. This is used to find the type of the node.
static func collect_node_info_by_filter(root_node: Node, target_signal: String, marker_function: Callable, filter_function: Callable) -> Array[NodeInfo]:
	var found_nodes: Array[Node] = NodeUtil.collect_nodes_in_children(root_node, filter_function)
	return collect_info_for_nodes(found_nodes, target_signal, marker_function)

## Collects the a [code]NodeInfo[/code] array based on all nodes below the given root node for a given signal. 
## For this, the built-in [method Node.find_children] method will be used.
## The marker function is a Callable (ConnectionInfo) -> bool. This is used to mark specific connections.
static func collect_node_info_by_class(root_node: Node, target_signal: String, marker_function: Callable, class_name_str: String, name_filter: String = "*") -> Array[NodeInfo]:
	var found_nodes: Array[Node] = root_node.find_children(name_filter, class_name_str, true, false)
	return collect_info_for_nodes(found_nodes, target_signal, marker_function)
	
## Collects the a [code]NodeInfo[/code] array based on the provided Array of nodes, for a given signal. 
## Consider using [method NodeConnectionChecker.collect_node_info_by_filter] or [method NodeConnectionChecker.collect_node_info_by_class] directly.
## The marker function is a Callable (ConnectionInfo) -> bool. This is used to mark specific connections.
static func collect_info_for_nodes(nodes: Array[Node], target_signal: String, marker_function: Callable) -> Array[NodeInfo]:
	var node_info: Array[NodeInfo] = []
	for node in nodes:
		var bi: NodeInfo = NodeInfo.new()
		bi.node_path = node.get_path()
		
		var connection_infos: Array[ConnectionInfo] = []		
		for connection: Dictionary in node.get_signal_connection_list(target_signal):
			var con_info: ConnectionInfo = ConnectionInfo.new()
			var callable: Callable = connection["callable"]
			con_info.connection_name = StringUtil.get_var_name(callable.get_object()) + ":" + callable.get_method()
			con_info.is_marked = marker_function.call(con_info)
			connection_infos.append(con_info)

		bi.connection_info = connection_infos
		node_info.append(bi)
	
	return node_info
	
## Uses [method print_rich] to output a given Array of [NodeInfo].
## Single marked connections for a node are green, multiple connections yellow, red otherwise.
## Usage example:
## [codeblock]
## func is_test_connection(con_info: ConnectionInfo) -> bool:
##     return con_info.connection_name.to_lower().contains("test")
##
## var info: Array[NodeConnectionChecker.NodeInfo] = NodeConnectionChecker.collect_node_info_by_class(get_tree().root, "pressed", is_test_connection, "BaseButton")
## print_info(info)
## [/codeblock]
static func print_info(found_info: Array[NodeConnectionChecker.NodeInfo]) -> void:
	const STR_TAB: String  = "\t"
	const STR_CORRECT: String = "✓"
	const STR_FALSE: String = "✖"
	const STR_TOO_MANY: String = "⚠"
	
	const COLOR_CORRECT: Color = Color.LIGHT_GREEN
	const COLOR_FALSE: Color = Color.INDIAN_RED
	const COLOR_IGNORE: Color = Color.DARK_GRAY

	const COLOR_TOO_MANY: Color = Color.YELLOW
		
	var res_string: String = ""

	# for each node info
	for node_info:NodeConnectionChecker.NodeInfo in found_info:

		# check num marked connections first
		var num_marked_connections: int = 0
		for connection: NodeConnectionChecker.ConnectionInfo in node_info.connection_info:
			if connection.is_marked:
				num_marked_connections += 1
		
		# collect connection info, i.e. names
		var connection_string: String = ""
		for connection: NodeConnectionChecker.ConnectionInfo in node_info.connection_info:
			var correct_color: Color = COLOR_CORRECT if num_marked_connections == 1 else COLOR_TOO_MANY
			var con_mark_char: String = STR_CORRECT if connection.is_marked else STR_FALSE
			var log_color: Color = correct_color if connection.is_marked else COLOR_IGNORE

			connection_string += STR_TAB + " [color=\""+log_color.to_html()+"\"]" + con_mark_char + " " + connection.connection_name + "[/color]\n"

		var btn_color: Color = COLOR_FALSE
		var mark_char: String = STR_FALSE
		if num_marked_connections > 1:
			btn_color = COLOR_TOO_MANY
			mark_char = STR_TOO_MANY
		elif num_marked_connections == 1:
			btn_color = COLOR_CORRECT
			mark_char = STR_CORRECT
			
		res_string += "\n[color=\""+btn_color.to_html()+"\"] " + mark_char + " " +node_info.node_path + ":[/color]\n" + connection_string
		
	print_rich(res_string)
