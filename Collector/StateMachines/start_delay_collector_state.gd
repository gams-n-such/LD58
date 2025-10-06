extends CollectorState


func _ready() -> void:
	super._ready()

func enter(prev_state : State) -> void:
	super.enter(prev_state)
	collector.global_position = collector.global_position + Vector3.DOWN * 100

func exit(next_state : State) -> void:
	collector.global_position = collector.global_position + Vector3.UP * 100
	collector.aim_spotlight.visible = true
	super.exit(next_state)

func update(delta: float) -> void:
	super.update(delta)

func physics_update(delta: float) -> void:
	super.physics_update(delta)

func tick(time_since_last_tick : float, time_to_next_tick : float) -> void:
	request_transition("TargetingCollectorState")
