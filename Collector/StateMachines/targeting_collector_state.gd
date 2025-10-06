extends CollectorState


func _ready() -> void:
	super._ready()

func enter(prev_state : State) -> void:
	super.enter(prev_state)
	collector.current_target = pick_random_treasure()
	collector.aim_spotlight.visible = true

func exit(next_state : State) -> void:
	super.exit(next_state)

func update(delta: float) -> void:
	super.update(delta)

func physics_update(delta: float) -> void:
	super.physics_update(delta)

func tick(time_since_last_tick : float, time_to_next_tick : float) -> void:
	super.tick(time_since_last_tick, time_to_next_tick)
	if collector.current_target:
		request_transition("FlyingCollectorState")
	else:
		request_transition("FinalCollectorState")

func pick_random_treasure() -> Treasure:
	return collector.get_remaining_treasure(false).pick_random()
