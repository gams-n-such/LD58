extends CollectorState

@export var wait_ticks : int = 5

@export var teleport_radius : float = 30.0

var remaining_ticks : int = 5

func _ready() -> void:
	super._ready()

func enter(prev_state : State) -> void:
	super.enter(prev_state)
	if collector.skip_next_wait:
		collector.skip_next_wait = false
		remaining_ticks = 0
	else:
		collector.global_position = Vector3(randf_range(-teleport_radius, teleport_radius), -20, randf_range(-teleport_radius, teleport_radius))
		collector.aim_spotlight.visible = false
		remaining_ticks = wait_ticks

func exit(next_state : State) -> void:
	collector.aim_spotlight.visible = true
	collector.global_position.y = collector.height
	super.exit(next_state)

func update(delta: float) -> void:
	super.update(delta)

func physics_update(delta: float) -> void:
	super.physics_update(delta)

func tick(time_since_last_tick : float, time_to_next_tick : float) -> void:
	super.tick(time_since_last_tick, time_to_next_tick)
	remaining_ticks -= 1
	if remaining_ticks <= 0:
		request_transition("TargetingCollectorState")
