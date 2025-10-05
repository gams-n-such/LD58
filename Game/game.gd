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
