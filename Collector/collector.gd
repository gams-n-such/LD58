class_name Collector
extends Node3D

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var aim_spotlight: SpotLight3D = %AimSpotlight
@onready var treasure_spot: TreasureSpot = %TreasureSpot

@onready var state_machine: StateMachine = %CollectorStateMachine

@export var height : float = 20.0

var current_target : Treasure = null

func _ready() -> void:
	Game.collector = self

#region Utils

func get_player_held_item() -> Node3D:
	if Game.player:
		return Game.player.held_item
	else:
		return null

func get_remaining_treasure(include_player_held : bool = false) -> Array[Treasure]:
	var result : Array[Treasure]
	result.assign(get_tree().get_nodes_in_group("Treasure"))
	if not include_player_held:
		result.erase(get_player_held_item())
	return result

#endregion
