class_name NodeUtil

## Convenience method to make all canvas items in [code]invisible_nodes[/code] invisible
## and make [code]visible_node[/code] visible. E.g. helpful for navigating different menus.
## The latter node will be set to visible even if it is present in [code]invisible_nodes[/code].
static func set_visible_only(visible_node: CanvasItem, invisible_nodes: Array[CanvasItem]) -> void:
	for inv_node in invisible_nodes:
		inv_node.visible = false
	
	visible_node.visible = true
	
## Recursively collects all children nodes below the given node that match the given filter function.
## The filter function is expected to have the following signature [code]func filter(node: Node) -> bool[/code]
## An example might be [code]collect_nodes_in_children(get_tree().root, func(node: Node) -> bool: return node is BaseButton)[/code]
static func collect_nodes_in_children(node: Node, filter: Callable) -> Array[Node]:
	var res: Array[Node] = []
	if filter.call(node):
		res.append(node)
		
	for child: Node in node.get_children():
		var children_nodes: Array[Node]= collect_nodes_in_children(child, filter)
		res.append_array(children_nodes)
				
	return res
