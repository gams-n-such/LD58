class_name TreasureSpot
extends Area3D

signal item_changed(old_item : Node3D, new_item : Node3D)

@onready var SPOT : Node3D = %TreasureRoot

var current_item : Node3D:
	get:
		if SPOT.get_child_count() > 0:
			return SPOT.get_child(0)
		else:
			return null

var current_treasure : Treasure:
	get:
		return current_item as Treasure

func _ready() -> void:
	pass # Replace with function body.

func interact(player : PlayerCharacter) -> void:
	var old_item : Node3D = current_item
	if player.is_holding_item():
		player.place_item(SPOT)
		assert(current_treasure)
		current_treasure.position = Vector3.ZERO
	if old_item:
		player.hold_item(old_item)
	var new_item : Node3D = current_item
	_on_item_changed(old_item, new_item)

func collect_item(new_root : Node3D = null) -> void:
	var previous_item := current_item
	if new_root:
		previous_item.reparent(new_root, false)
	else:
		previous_item.reparent(get_tree().root, true)
	previous_item.rotation = Vector3.ZERO
	previous_item.scale = Vector3.ONE
	_on_item_changed(previous_item, null)

func _on_item_changed(old : Node3D, new : Node3D) -> void:
	item_changed.emit(old, new)
