@tool
class_name Treasure
extends Area3D


@onready var MESH := %Mesh

@export var resource : TreasureResource:
	get:
		return resource
	set(new_res):
		resource = new_res
		if is_inside_tree():
			update_visuals()

func _ready() -> void:
	update_visuals()

func update_visuals() -> void:
	if not is_node_ready():
		await ready
	MESH.mesh = resource.mesh if resource else null

func interact(player : PlayerCharacter) -> void:
	if not player.is_holding_item():
		player.hold_item(self)
