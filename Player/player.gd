extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta: float) -> void:
	_update_camera(delta)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		interact()

func _unhandled_input(event: InputEvent) -> void:
	_mouse_moving = event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED
	if _mouse_moving:
		var mouse_event = event as InputEventMouseMotion
		_input_yaw = -mouse_event.relative.x * mouse_sensitivity
		_input_pitch = -mouse_event.relative.y * mouse_sensitivity

func _physics_process(delta: float) -> void:
	_process_input(delta)


func _process_input(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("walk_left", "walk_right", "walk_forward", "walk_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


#region Items

@export var INTERACTION_PROBE : RayCast3D

var held_item : Node3D:
	get:
		if %HoldAnchor.get_child_count() > 0:
			return %HoldAnchor.get_child(0)
		else:
			return null

func interact() -> void:
	if INTERACTION_PROBE.is_colliding():
		var collider = INTERACTION_PROBE.get_collider()
		if collider is Node3D:
			# FIXME: find by type
			var treasure := collider as Treasure
			if not treasure:
				treasure = collider.find_parent("Treasure") as Treasure
			if treasure and not is_holding_item():
				hold_item(treasure)

func is_holding_item() -> bool:
	return held_item != null

func hold_item(item : Node3D) -> void:
	if not item:
		return
	if is_holding_item():
		release_item()
	item.reparent(%HoldAnchor, false)
	item.position = Vector3.ZERO

func release_item() -> Node3D:
	assert(is_holding_item())
	var previously_held := held_item
	held_item.reparent(get_tree().root, true)
	return previously_held

#endregion


#region Camera

@export var CAMERA_CONTROLLER : Node3D
@export var CAMERA : Camera3D

const MIN_TILT = deg_to_rad(-90)
const MAX_TILT = deg_to_rad(90)

var _mouse_moving : bool = false
var _input_yaw : float
var _input_pitch : float
var _mouse_rotation : Vector3
var _player_rotation : Vector3
var _camera_rotation : Vector3
@export var mouse_sensitivity : float = 0.5

var _saved_yaw_input : float

func _update_camera(delta: float) -> void:
	_saved_yaw_input = _input_yaw
	_mouse_rotation.x += _input_pitch * delta
	_mouse_rotation.x = clamp(_mouse_rotation.x, MIN_TILT, MAX_TILT)
	_mouse_rotation.y += _input_yaw * delta
	
	_player_rotation = Vector3(0, _mouse_rotation.y, 0)
	_camera_rotation = Vector3(_mouse_rotation.x, 0, 0)
	
	CAMERA_CONTROLLER.transform.basis = Basis.from_euler(_camera_rotation)
	CAMERA_CONTROLLER.rotation.z = 0
	
	# TODO: revisit
	global_transform.basis = Basis.from_euler(_player_rotation)
	
	_input_pitch = 0
	_input_yaw = 0

#endregion
