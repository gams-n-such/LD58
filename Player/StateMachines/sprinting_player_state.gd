class_name SprintingPlayerState
extends PlayerMovementState

@export var MAX_ANIM_SPEED : float = 1.6
@export var SPEED = 7.0
@export var ACCELERATION = 0.2
@export var DECELERATION = 0.5

var SLIDING_SPEED_THRESHOLD : float = 5.0

func enter(prev_state : State) -> void:
	AnimPlayer.play("sprinting", 0.5, 1.0)

func exit(next_state : State) -> void:
	AnimPlayer.speed_scale = 1.0

func update(delta: float) -> void:
	super.update(delta)
	var player_speed : float = Player.velocity.length()
	set_animation_speed(player_speed)
	if player_speed == 0:
		request_transition("IdlePlayerState")
	elif Input.is_action_just_pressed("jump"):
		request_transition("JumpingPlayerState")
	elif Input.is_action_just_released("sprint"):
		request_transition("WalkingPlayerState")

func movement_update(delta: float) -> void:
	Player._process_gravity(delta)
	Player._process_input(SPEED, ACCELERATION, DECELERATION)
	Player._process_velocity()

func set_animation_speed(player_speed : float) -> void:
	var anim_speed = remap(player_speed, 0.0, SPEED, 0.0, MAX_ANIM_SPEED)
	AnimPlayer.speed_scale = anim_speed
