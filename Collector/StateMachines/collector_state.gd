class_name CollectorState
extends State


var collector : Collector = null


func _ready() -> void:
	await owner.ready
	collector = owner as Collector


func enter(prev_state : State) -> void:
	super.enter(prev_state)

func exit(next_state : State) -> void:
	super.exit(next_state)

func update(delta: float) -> void:
	super.update(delta)

func physics_update(delta: float) -> void:
	super.physics_update(delta)

func tick(time_since_last_tick : float, time_to_next_tick : float) -> void:
	pass
