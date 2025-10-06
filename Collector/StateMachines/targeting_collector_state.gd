extends CollectorState


func _ready() -> void:
	super._ready()

func enter(prev_state : State) -> void:
	collector.current_target = pick_random_treasure()

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

func get_all_treasures() -> Array[Treasure]:
	var result : Array[Treasure]
	result.assign(get_tree().get_nodes_in_group("Treasure"))
	return result

func pick_random_treasure() -> Treasure:
	return get_all_treasures().pick_random()
