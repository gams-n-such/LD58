class_name Treasure
extends Area3D


@onready var MESH := %Mesh

@export var resource : TreasureResource:
	get:
		return resource
	set(new_res):
		resource = new_res
		update_visuals()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_visuals()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_visuals() -> void:
	if not is_node_ready():
		await ready
	MESH.mesh = resource.mesh
