extends Node

signal finished

func _ready() -> void:
	Game.can_pause = false
	Game.set_main_ambience_playing(true)
	var outro_tween := get_tree().create_tween()
	outro_tween.tween_property(%Root, "modulate", Color.WHITE, 5.0)
	outro_tween.tween_property(%Text, "modulate", Color.WHITE, 3.0)
	await outro_tween.finished
	await %Curtain.fade_out(3.0)
	await get_tree().create_timer(5.0).timeout
	await %Curtain.fade_in(3.0)
	finished.emit()
