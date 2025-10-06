extends CollectorState


func _ready() -> void:
	super._ready()

func enter(prev_state : State) -> void:
	super.enter(prev_state)
	Game.player.camera_lock_x = true
	Game.player.movement_lock = true
	collector.animation_player.play("final")
	collector.aim_spotlight.visible = false
	collector.treasure_spot.active = true
	collector.reparent(Game.player)
	collector.position = Vector3.FORWARD * 10.0
	collector.rotation_degrees = Vector3(0.0, 180, 0.0)
	var tween := get_tree().create_tween()
	tween.tween_property(collector, "position", Vector3.FORWARD * 2.0, 5)

func exit(next_state : State) -> void:
	super.exit(next_state)

func update(delta: float) -> void:
	super.update(delta)

func physics_update(delta: float) -> void:
	super.physics_update(delta)

func tick(time_since_last_tick : float, time_to_next_tick : float) -> void:
	super.tick(time_since_last_tick, time_to_next_tick)
