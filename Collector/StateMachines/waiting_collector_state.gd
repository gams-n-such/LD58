extends CollectorState

@export var wait_ticks : int = 5

var remaining_ticks : int = 5

func _ready() -> void:
	super._ready()

func enter(prev_state : State) -> void:
	super.enter(prev_state)
	collector.aim_spotlight.visible = false
	remaining_ticks = wait_ticks

func exit(next_state : State) -> void:
	collector.aim_spotlight.visible = true
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
