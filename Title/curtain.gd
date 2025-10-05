class_name Curtain
extends Panel

@onready var FADER : AnimationPlayer = %Fader

func fade_in(fade_time : float) -> void:
	var fade_speed : float = 1.0 / fade_time if fade_time > 0.0 else 100.0
	FADER.play("fade_in", -1, fade_speed)
	visible = true
	await FADER.animation_finished

func fade_out(fade_time : float) -> void:
	var fade_speed : float = 1.0 / fade_time if fade_time > 0.0 else 100.0
	FADER.play("fade_in", -1, -fade_speed, true)
	await FADER.animation_finished
	visible = false
