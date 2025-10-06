extends CollectorState


func _ready() -> void:
	super._ready()

func enter(prev_state : State) -> void:
	super.enter(prev_state)
	Game.clock.stop()
	Game.player.camera_lock_x = true
	Game.player.movement_lock = true
	collector.animation_player.play("final")
	collector.aim_spotlight.visible = false
	collector.treasure_spot.active = true
	collector.reparent(Game.player)
	var forward_offset := Vector3.FORWARD * 10.0
	var vertical_offset := Vector3.UP * 20.0
	var final_offset := Vector3.FORWARD * 2.0
	collector.position = forward_offset + vertical_offset
	collector.rotation_degrees = Vector3(0.0, 180, 0.0)
	var tween := get_tree().create_tween()
	tween.tween_property(collector, "position", forward_offset, 5)
	tween.tween_property(collector, "position", final_offset, 5)
	await collector.treasure_spot.item_changed
	Game.player.interact_lock = true
	Game.game_over.emit(true)

func exit(next_state : State) -> void:
	super.exit(next_state)

func update(delta: float) -> void:
	super.update(delta)

func physics_update(delta: float) -> void:
	super.physics_update(delta)

func tick(time_since_last_tick : float, time_to_next_tick : float) -> void:
	super.tick(time_since_last_tick, time_to_next_tick)
