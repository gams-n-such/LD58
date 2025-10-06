extends CollectorState


@export var speed : float = 10.0

func _ready() -> void:
	super._ready()

func enter(prev_state : State) -> void:
	super.enter(prev_state)
	assert(collector.current_target)
	var next_point := collector.global_position
	next_point.y = collector.height
	var distance := (next_point - collector.global_position).length()
	var move_tween := get_tree().create_tween()
	move_tween.tween_property(collector, "global_position", next_point, distance / speed)
	await move_tween.finished
	request_transition("WaitingCollectorState")

func exit(next_state : State) -> void:
	if collector.current_target and  collector.current_target.get_parent_node_3d() == collector:
		collector.current_target.queue_free()
		var treasure := collector.get_remaining_treasure(true)
		if treasure.is_empty():
			Game.lose()
	super.exit(next_state)

func update(delta: float) -> void:
	super.update(delta)

func physics_update(delta: float) -> void:
	super.physics_update(delta)

func tick(time_since_last_tick : float, time_to_next_tick : float) -> void:
	super.tick(time_since_last_tick, time_to_next_tick)
