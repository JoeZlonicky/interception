class_name ConfigurationWarnings


static func missing_required_properties(node: Node) -> String:
	var s = node.name
	if node.owner:
		s = node.owner.name + "/" + s 
	s += " missing required properties"
	return s


static func invalid_property(node: Node, property_name: String) -> String:
	var s = node.name
	if node.owner:
		s = node.owner.name + "/" + s 
	s += " has invalid '" + property_name + "'"
	s += " of '" + str(node.get(property_name)) + "'"
	return s
