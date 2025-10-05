extends Node3D

@onready var TIMER := %TickTimer
@export var autostart : bool = false

signal tick

func _ready() -> void:
	if autostart:
		start()

func start() -> void:
	TIMER.start()

func stop() -> void:
	TIMER.stop()

func set_tick_rate(bpm : float) -> void:
	if bpm <= 0:
		stop()
		return
	TIMER.wait_time = 1 / bpm
	if TIMER.is_stopped():
		start()

func _on_tick_timer_timeout() -> void:
	play_sound()
	tick.emit()

func play_sound() -> void:
	%TickingSound.play()
	#%TickingSound3D.play()
