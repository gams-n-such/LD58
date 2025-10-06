extends StateMachine


var collector : Collector = null


func _ready() -> void:
	await owner.ready
	collector = owner as Collector

func _on_global_tick(time_since_last_tick : float, time_to_next_tick : float) -> void:
	if current_state is CollectorState:
		(current_state as CollectorState).tick(time_since_last_tick, time_to_next_tick)
