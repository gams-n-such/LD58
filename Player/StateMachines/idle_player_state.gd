class_name IdlePlayerState
extends PlayerMovementState

@export var SPEED = 5.0
@export var ACCELERATION = 0.2
@export var DECELERATION = 0.5

func enter(prev_state : State) -> void:
	if AnimPlayer.is_playing() and AnimPlayer.current_animation == "jump_end":
		await AnimPlayer.animation_finished
	AnimPlayer.pause()

func exit(next_state : State) -> void:
	pass

func update(delta: float) -> void:
	super.update(delta)
	# TODO: disable input in debug camera mode
	if Input.is_action_just_pressed("jump"):
		request_transition("JumpingPlayerState")
	elif Player.velocity.length() > 0.0 and Player.is_on_floor():
		request_transition("WalkingPlayerState")
	elif Player.velocity.y < -3.0 and not Player.is_on_floor():
		request_transition("FallingPlayerState")

func movement_update(delta: float) -> void:
	Player._process_gravity(delta)
	Player._process_input(SPEED, ACCELERATION, DECELERATION)
	Player._process_velocity()
