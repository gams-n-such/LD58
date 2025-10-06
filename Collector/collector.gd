class_name Collector
extends Node3D

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var aim_spotlight: SpotLight3D = %AimSpotlight
@onready var treasure_spot: TreasureSpot = %TreasureSpot


var current_target : Treasure = null

func _ready() -> void:
	Game.collector = self
