extends Node

signal finished

func _ready() -> void:
	Game.can_pause = false
	var outro_tween := get_tree().create_tween()
	outro_tween.tween_property(%Root, "self_modulate", Color.WHITE, 3.0)
	await outro_tween.finished
	await %Curtain.fade_in(3.0)
	await get_tree().create_timer(5.0).timeout
	await %Curtain.fade_out(3.0)
	finished.emit()
