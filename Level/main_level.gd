extends Node

@onready var PLAYER: PlayerCharacter = %Player
@onready var COLLECTOR: Collector = %Collector
@onready var CLOCK: Clock = %Clock

@export var first_shrine : Shrine
@export var first_item : Treasure

func _ready() -> void:
	await first_item.taken
	first_shrine.erect()
	await first_shrine.item_changed
	for shrine in get_tree().get_nodes_in_group("Shrines"):
		(shrine as Shrine).erect()
	var treasures_tween := get_tree().create_tween()
	treasures_tween.tween_property(%TreasuresRoot, "global_position", Vector3.UP * 0.8, 3)
	await treasures_tween.finished
	CLOCK.start()
