extends CollectorState

@export var ticks_duration : int = 3
@export var grab_distance : float = 0.5

var ticks_left : int = 3
var move_delta : Vector3

func _ready() -> void:
	super._ready()

func enter(prev_state : State) -> void:
	super.enter(prev_state)
	collector.aim_spotlight.visible = false
	ticks_left = ticks_duration
	move_delta = (get_target_position() - collector.global_position) / float(ticks_left)
	assert(collector.current_target)
	if not collector.is_target_held():
		collector.current_target.taken.connect(_on_player_grabbed_target)
	else:
		request_transition("RetreatingCollectorState")

func exit(next_state : State) -> void:
	if collector.current_target:
		collector.current_target.taken.disconnect(_on_player_grabbed_target)
	super.exit(next_state)

func update(delta: float) -> void:
	super.update(delta)

func physics_update(delta: float) -> void:
	super.physics_update(delta)

func tick(time_since_last_tick : float, time_to_next_tick : float) -> void:
	super.tick(time_since_last_tick, time_to_next_tick)
	var next_point := collector.global_position + move_delta
	collector.look_at(next_point)
	var move_tween := get_tree().create_tween()
	move_tween.tween_property(collector, "global_position", next_point, time_to_next_tick / 2.0)
	ticks_left -= 1
	if ticks_left <= 0:
		await move_tween.finished
		if not collector.is_target_held():
			collector.current_target.set_collision_enabled(false)
			collector.current_target.reparent(collector, true)
		else:
			collector.skip_next_wait = true
		request_transition("RetreatingCollectorState")

func get_target_position() -> Vector3:
	return collector.current_target.global_position + Vector3.UP * grab_distance

func _on_player_grabbed_target() -> void:
	if ticks_left > 0:
		collector.skip_next_wait = true
		request_transition("RetreatingCollectorState")
