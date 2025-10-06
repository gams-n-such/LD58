extends Node

@export var title_scene : PackedScene
@export var intro_scene : PackedScene
@export var gameplay_scene : PackedScene
@export var pause_scene : PackedScene


signal game_over(win : bool)
signal tick(time_since_last_tick : float, time_to_next_tick : float)

var player : PlayerCharacter = null
var collector : Collector = null
var clock : Clock:
	get:
		return clock
	set(new_clock):
		if clock:
			clock.tick.disconnect(_on_clock_tick)
		clock = new_clock
		if clock:
			clock.tick.connect(_on_clock_tick)


func _ready() -> void:
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dev_exit"):
		exit()
	if event.is_action_pressed("pause"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_CAPTURED

func start_intro() -> void:
	get_tree().change_scene_to_packed(intro_scene)

func restart(from_title : bool = true) -> void:
	get_tree().change_scene_to_packed(title_scene if from_title else gameplay_scene)

func win() -> void:
	game_over.emit(true)

func lose() -> void:
	game_over.emit(false)

func exit() -> void:
	get_tree().quit()

#region Game Flow

func _on_clock_tick(time_since_last_tick : float, time_to_next_tick : float) -> void:
	tick.emit(time_since_last_tick, time_to_next_tick)

#endregion

#region Ambience

@onready var MAIN_AMBIENCE := %MainAmbience

func set_main_ambience_playing(play : bool, fade_time : float = 1.0) -> void:
	if play == MAIN_AMBIENCE.playing:
		return
	var fade_tween := get_tree().create_tween()
	if play:
		MAIN_AMBIENCE.playing = true
		fade_tween.tween_property(MAIN_AMBIENCE, "volume_db", 0.0, fade_time)
		await fade_tween.finished
	else:
		fade_tween.tween_property(MAIN_AMBIENCE, "volume_db", -80.0, fade_time)
		await fade_tween.finished
		MAIN_AMBIENCE.playing = false

#endregion

#region Utils

func get_player_held_item() -> Node3D:
	if player:
		return player.held_item
	else:
		return null

func get_remaining_treasures() -> Array[Treasure]:
	var result : Array[Treasure]
	result.assign(get_tree().get_nodes_in_group("Treasure"))
	return result
	
#endregion
