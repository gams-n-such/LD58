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

var active : bool:
	get:
		return SPOT.active


func erect() -> void:
	if active:
		return
	SPOT.active = true
	%CrumblingSFX.play()
	var tween = get_tree().create_tween()
	var target_pos := global_position
	target_pos.y = 0
	tween.tween_property(self, "global_position", target_pos, 3)
	await tween.finished

func destroy() -> void:
	if not active:
		return
	SPOT.active = false
	%CrumblingSFX.play()
	var tween = get_tree().create_tween()
	var target_pos := global_position
	target_pos.y = -3
	tween.tween_property(self, "global_position", target_pos, 3)
	tween.tween_callback(queue_free)


func _on_treasure_spot_item_changed(old_item: Node3D, new_item: Node3D) -> void:
	item_changed.emit(old_item, new_item)
