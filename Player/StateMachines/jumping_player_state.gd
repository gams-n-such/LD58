class_name JumpingPlayerState
extends PlayerMovementState

@export var SPEED = 6.0
var starting_velocity : Vector3
@export var ACCELERATION = 0.1
@export var DECELERATION = 0.25
@export var JUMP_VELOCITY = 4.5
@export_range(0.0, 1.0, 0.01) var INPUT_MULTIPLIER : float = 0.85
@export var JUMP_AUDIO_STREAM : AudioStreamPlayer3D
@export var LANDING_AUDIO_STREAM : AudioStreamPlayer3D


func enter(prev_state : State) -> void:
	starting_velocity = Player.velocity
	starting_velocity.y = 0.0
	jump()
	AnimPlayer.play("jump_start")

func exit(next_state : State) -> void:
	#_double_jump = false
	pass

func update(delta: float) -> void:
	super.update(delta)

func jump() -> void:
	Player.velocity.y = JUMP_VELOCITY
	if JUMP_AUDIO_STREAM:
		JUMP_AUDIO_STREAM.play()

func movement_update(delta: float) -> void:
	Player._process_gravity(delta)
	Player._process_input(SPEED, ACCELERATION, DECELERATION)
	Player._process_velocity()
	
	if Player.is_on_floor():
		AnimPlayer.play("jump_end")
		if LANDING_AUDIO_STREAM:
			LANDING_AUDIO_STREAM.play()
		request_transition("IdlePlayerState")
