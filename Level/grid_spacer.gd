@tool
extends Node3D


@export var grid_space : float = 1.0
@export var grid_size : int = 4

@export_tool_button("Arrange") var arrange := arrange_child_nodes

func arrange_child_nodes() -> void:
	var children_3d := get_children_3d()
	for x in range(grid_size):
		for z in range(grid_size):
			var idx := x * grid_size + z
			if idx < children_3d.size():
				var child := children_3d[idx]
				if child:
					child.position = Vector3(grid_space * x, 0.0, grid_space * z)

func get_children_3d() -> Array[Node3D]:
	var children := get_children()
	var result : Array[Node3D]
	for child in children:
		if child is Node3D:
			result.append(child as Node3D)
	return result
