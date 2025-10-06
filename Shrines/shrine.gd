class_name Shrine
extends Node3D

signal item_changed(old_item: Node3D, new_item: Node3D)

@onready var SPOT: TreasureSpot = %TreasureSpot

var placed_item : Node3D:
	get:
		return SPOT.current_item

var placed_treasure : Treasure:
	get:
		return SPOT.current_item as Treasure

func has_item() -> bool:
	return placed_item != null


func _ready() -> void:
	pass

func destroy() -> void:
	%CrumblingSFX.play()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", position + Vector3.DOWN * 3, 5)
	tween.tween_callback(queue_free)


func _on_treasure_spot_item_changed(old_item: Node3D, new_item: Node3D) -> void:
	item_changed.emit(old_item, new_item)
