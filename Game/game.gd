extends Node

@export var title_scene : PackedScene
@export var gameplay_scene : PackedScene


func _ready() -> void:
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dev_exit"):
		exit()
	if event.is_action_pressed("pause"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_CAPTURED

func restart(from_title : bool = true) -> void:
	get_tree().change_scene_to_packed(title_scene if from_title else gameplay_scene)

func exit() -> void:
	get_tree().quit()

#region Ambience

@onready var MAIN_AMBIENCE := %MainAmbience
@onready var MAIN_AMBIENCE_FADER := %AmbienceFades

func set_main_ambience_playing(play : bool, fade_time : float = 1.0) -> void:
	if play == MAIN_AMBIENCE.playing:
		return
	var fade_speed : float = 1.0 / fade_time if fade_time > 0.0 else 100.0
	if play:
		MAIN_AMBIENCE_FADER.play("main_ambience_fade_in", -1, fade_speed)
		MAIN_AMBIENCE.playing = true
		await MAIN_AMBIENCE_FADER.animation_finished
	else:
		MAIN_AMBIENCE_FADER.play("main_ambience_fade_in", -1, -fade_speed, true)
		await MAIN_AMBIENCE_FADER.animation_finished
		MAIN_AMBIENCE.playing = false

#endregion
