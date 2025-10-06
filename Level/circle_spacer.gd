@tool
extends Node3D

@export var radius : float = 1.0

@export_tool_button("Arrange") var arrange := arrange_child_nodes

func arrange_child_nodes() -> void:
	var children_3d := get_children_3d()
	if children_3d.is_empty():
		return
	var offset := Vector3(0, 0, -radius)
	var delta_angle := 2 * PI / children_3d.size()
	for child in children_3d:
		if child:
			child.position = offset
			offset = offset.rotated(Vector3.UP, delta_angle)

func get_children_3d() -> Array[Node3D]:
	var children := get_children()
	var result : Array[Node3D]
	for child in children:
		if child is Node3D:
			result.append(child as Node3D)
	return result
