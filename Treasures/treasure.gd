@tool
class_name Treasure
extends Area3D

signal taken
signal placed(new_root)

@onready var MESH := %Mesh
@onready var mesh_root: Node3D = %MeshRoot

@export var rot_speed_degrees : float = 5.0

@export var resource : TreasureResource:
	get:
		return resource
	set(new_res):
		resource = new_res
		if is_inside_tree():
			update_visuals()

func _ready() -> void:
	update_visuals()

func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		mesh_root.rotate(Vector3.UP, deg_to_rad(rot_speed_degrees) * delta)

func update_visuals() -> void:
	if not is_node_ready():
		await ready
	if resource:
		MESH.mesh = resource.mesh

func interact(player : PlayerCharacter) -> void:
	if not player.is_holding_item():
		player.hold_item(self)
		taken.emit()

func place() -> void:
	placed.emit(get_parent_node_3d())

func set_collision_enabled(enable : bool) -> void:
	%Collision.disabled = not enable
