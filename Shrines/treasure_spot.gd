extends Area3D

@onready var SPOT : Node3D = %TreasureRoot

var current_treasure : Node3D:
	get:
		if SPOT.get_child_count() > 0:
			return SPOT.get_child(0)
		else:
			return null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func interact(player : PlayerCharacter) -> void:
	if player.is_holding_item():
		player.place_item(SPOT)
		assert(current_treasure)
		current_treasure.position = Vector3.ZERO
	elif current_treasure:
		player.hold_item(current_treasure)
