extends CollectorState

@export var starting_speed : float = 5.0
@export var speed_per_tick : float = 0.05
@export var rectilinear_movement : bool = true

func _ready() -> void:
	super._ready()

func enter(prev_state : State) -> void:
	super.enter(prev_state)
	collector.global_position.y = collector.height
	collector.aim_spotlight.visible = true
	if collector.is_target_held() or not collector.current_target:
		await get_tree().create_timer(0.1).timeout
		request_transition("FinalCollectorState")
	else:
		collector.current_target.taken.connect(_on_player_grabbed_target)

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
	var next_point := get_next_position()
	collector.look_at(next_point)
	var move_tween := get_tree().create_tween()
	move_tween.tween_property(collector, "global_position", next_point, time_to_next_tick / 2.0)
	if next_point.distance_to(get_target_fly_position()) < 1.0:
		await move_tween.finished
		request_transition("GrabbingCollectorState")

func _on_player_grabbed_target() -> void:
	request_transition("TargetingCollectorState")

func get_target_fly_position() -> Vector3:
	var result := collector.current_target.global_position
	result.y = collector.height
	return result

func get_next_position() -> Vector3:
	var collector_location := collector.global_position
	var target_location := get_target_fly_position()
	var delta_to_target := target_location - collector_location
	var horizontal_delta := delta_to_target
	horizontal_delta.y = 0.0
	var speed := get_speed()
	var result := collector_location
	if rectilinear_movement:
		var pick_x : bool = randi_range(0, 1)
		if pick_x and horizontal_delta.x < 0.1:
			pick_x = false
		elif not pick_x and horizontal_delta.z < 0.1:
			pick_x = true
		var axis_delta := Vector3(horizontal_delta.x, 0.0, 0.0) if pick_x else Vector3(0.0, 0.0, horizontal_delta.z)
		axis_delta.x = clampf(horizontal_delta.x, -speed, speed)
		axis_delta.z = clampf(horizontal_delta.z, -speed, speed)
		result = collector_location + axis_delta
	else:
		var distance := horizontal_delta.length()
		if distance < speed:
			result = collector_location + horizontal_delta
		else:
			var direction := horizontal_delta.normalized()
			result = collector_location + direction * speed
	return result

func get_speed() -> float:
	return starting_speed + speed_per_tick * Game.clock.num_ticks
