class_name Collector
extends Node3D

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var aim_spotlight: SpotLight3D = %AimSpotlight
@onready var treasure_spot: TreasureSpot = %TreasureSpot

@onready var state_machine: StateMachine = %CollectorStateMachine

@export var height : float = 20.0

var current_target : Treasure = null
var skip_next_wait : bool = false

func _ready() -> void:
	Game.collector = self

#region Utils

func is_target_held() -> bool:
	return current_target != null and current_target == get_player_held_item() 

func get_player_held_item() -> Node3D:
	if Game.player:
		return Game.player.held_item
	else:
		return null

func get_remaining_treasure(include_player_held : bool = false) -> Array[Treasure]:
	var result : Array[Treasure]
	var all_treasure := get_tree().get_nodes_in_group("Treasure")
	for item in all_treasure:
		if item and not item.is_queued_for_deletion():
			result.append(item as Treasure)
	if not include_player_held:
		result.erase(get_player_held_item())
	return result

func get_remaining_shrines(empty : bool) -> Array[Shrine]:
	var result : Array[Shrine]
	var all_shrines := get_tree().get_nodes_in_group("Shrines")
	for node in all_shrines:
		if node and not node.is_queued_for_deletion() and node is Shrine:
			var shrine := node as Shrine
			if shrine.active and shrine.has_item() == not empty:
				result.append(node as Shrine)
	return result

func get_random_empty_shrine() -> Shrine:
	return get_remaining_shrines(true).pick_random()

#endregion
