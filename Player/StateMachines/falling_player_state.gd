class_name FallingPlayerState
extends PlayerMovementState

@export var SPEED = 5.0
@export var ACCELERATION = 0.1
@export var DECELERATION = 0.25
@export_range(0.0, 1.0, 0.01) var INPUT_MULTIPLIER : float = 0.85
@export var LANDING_AUDIO_STREAM : AudioStreamPlayer3D

func enter(prev_state : State) -> void:
	AnimPlayer.pause()

func exit(next_state : State) -> void:
	pass

func update(delta: float) -> void:
	super.update(delta)

func movement_update(delta: float) -> void:
	Player._process_gravity(delta)
	Player._process_input(SPEED * INPUT_MULTIPLIER, ACCELERATION, DECELERATION)
	Player._process_velocity()
	
	if Player.is_on_floor():
		AnimPlayer.play("jump_end")
		if LANDING_AUDIO_STREAM:
			LANDING_AUDIO_STREAM.play()
		request_transition("IdlePlayerState")
