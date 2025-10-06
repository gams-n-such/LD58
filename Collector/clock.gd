class_name Clock
extends Node3D

@onready var TIMER := %TickTimer
@export var autostart : bool = false

signal tick(time_since_last_tick : float, time_to_next_tick : float)

var last_tick_time : float = 0.0
var num_ticks : int = 0

func _ready() -> void:
	Game.clock = self
	if autostart:
		start()

func start() -> void:
	last_tick_time = _get_time_sec()
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
	perform_tick()

func perform_tick() -> void:
	play_sound()
	var prev_time := last_tick_time
	last_tick_time = _get_time_sec()
	num_ticks = num_ticks + 1
	tick.emit(last_tick_time - prev_time, TIMER.wait_time)

func play_sound() -> void:
	%TickingSound.play()
	#%TickingSound3D.play()

func _get_time_sec() -> float:
	#var float_ticks : float = Time.get_ticks_msec()
	return float(Time.get_ticks_msec()) * 0.001
