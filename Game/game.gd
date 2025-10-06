extends Node

@export var title_scene : PackedScene
@export var intro_scene : PackedScene
@export var gameplay_scene : PackedScene
@export var pause_scene : PackedScene
@export var outro_scene : PackedScene


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
		set_paused(not is_paused())

#region Pause

var can_pause : bool = false
var active_pause : Node = null

func is_paused() -> bool:
	return active_pause != null

func set_paused(pause : bool) -> void:
	if pause == is_paused():
		return
	if pause:
		if can_pause:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			active_pause = pause_scene.instantiate()
			get_tree().root.add_child(active_pause)
	else:
		active_pause.queue_free()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
#endregion

func start_intro() -> void:
	get_tree().change_scene_to_packed(intro_scene)

func start_outro() -> void:
	var outro := outro_scene.instantiate()
	get_tree().root.add_child(outro)
	await outro.finished
	restart(true)

func restart(from_title : bool = true) -> void:
	get_tree().change_scene_to_packed(title_scene if from_title else gameplay_scene)

func win() -> void:
	game_over.emit(true)
	start_outro()

func lose() -> void:
	game_over.emit(false)
	restart(true)

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
