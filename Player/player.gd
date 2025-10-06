class_name PlayerCharacter
extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var ANIMATION_PLAYER : AnimationPlayer = %AnimationPlayer

var camera_lock_x : bool = false
var camera_lock_y : bool = false
var movement_lock : bool = false


func _ready() -> void:
	Game.player = self
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
	#_process_input_(delta)
	pass

func _process_gravity(delta : float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

@warning_ignore("unused_parameter")
func _process_input(speed : float, acceleration : float, deceleration : float) -> void:
	if not is_processing_input():
		return
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("walk_left", "walk_right", "walk_forward", "walk_backward") if not movement_lock else Vector2.ZERO
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

func _process_velocity() -> void:
	move_and_slide()


#region Items

@export var INTERACTION_PROBE : RayCast3D

@onready var HOLD_ANCHOR: Node3D = %HoldAnchor

signal item_taken(new_item)
signal item_placed(item, new_root)

var interact_lock : bool = false

var held_item : Node3D:
	get:
		if HOLD_ANCHOR.get_child_count() > 0:
			return HOLD_ANCHOR.get_child(0)
		else:
			return null

var held_treasure : Treasure:
	get:
		return held_item as Treasure

func find_interaction_target() -> Node3D:
	if INTERACTION_PROBE.is_colliding():
		var collider = INTERACTION_PROBE.get_collider()
		if collider is Node3D:
			return collider
	return null

func interact() -> void:
	if interact_lock:
		return
	var target := find_interaction_target()
	if target and target.has_method("interact"):
		target.interact(self)
	elif is_holding_item():
		place_item()

func is_holding_item() -> bool:
	return held_item != null

func hold_item(item : Node3D) -> void:
	if not item:
		return
	if is_holding_item():
		place_item()
	item.reparent(%HoldAnchor, false)
	item.position = Vector3.ZERO
	item.scale = Vector3.ONE
	if item is Treasure:
		item.process_mode = Node.PROCESS_MODE_DISABLED
	item_taken.emit(item)

func place_item(new_root : Node3D = null) -> Node3D:
	assert(is_holding_item())
	var previously_held := held_item
	if new_root:
		previously_held.reparent(new_root, false)
	else:
		previously_held.reparent(get_tree().root, true)
	previously_held.rotation = Vector3.ZERO
	previously_held.scale = Vector3.ONE
	item_placed.emit(previously_held, previously_held.get_parent_node_3d())
	if previously_held is Treasure:
		previously_held.process_mode = Node.PROCESS_MODE_INHERIT
		(previously_held as Treasure).place()
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
	_mouse_rotation.x += _input_pitch * delta if not camera_lock_y else 0.0
	_mouse_rotation.x = clamp(_mouse_rotation.x, MIN_TILT, MAX_TILT)
	_mouse_rotation.y += _input_yaw * delta if not camera_lock_x else 0.0
	
	_player_rotation = Vector3(0, _mouse_rotation.y, 0)
	_camera_rotation = Vector3(_mouse_rotation.x, 0, 0)
	
	CAMERA_CONTROLLER.transform.basis = Basis.from_euler(_camera_rotation)
	CAMERA_CONTROLLER.rotation.z = 0
	
	# TODO: revisit
	global_transform.basis = Basis.from_euler(_player_rotation)
	
	_input_pitch = 0
	_input_yaw = 0

#endregion
