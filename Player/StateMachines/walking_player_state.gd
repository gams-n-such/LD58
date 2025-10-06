class_name WalkingPlayerState
extends PlayerMovementState

@export var MAX_ANIM_SPEED : float = 2.2

@export var SPEED = 5.0
@export var ACCELERATION = 0.2
@export var DECELERATION = 0.5

func enter(prev_state : State) -> void:
	AnimPlayer.play("walking", -1.0, 1.0)

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
	elif Input.is_action_pressed("sprint") and Player.is_on_floor():
		request_transition("SprintingPlayerState")

func movement_update(delta: float) -> void:
	Player._process_gravity(delta)
	Player._process_input(SPEED, ACCELERATION, DECELERATION)
	Player._process_velocity()

func set_animation_speed(player_speed : float) -> void:
	var anim_speed = remap(player_speed, 0.0, SPEED, 0.0, MAX_ANIM_SPEED)
	AnimPlayer.speed_scale = anim_speed
