extends CharacterBody3D

signal place_block
signal mine_block
signal highlight_block

const SPEED = 5.0
const JUMP_VELOCITY = 5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


# accumulators
var rot_x = 0
var rot_y = 0

var mouse_sens = 0.005

var camera_rotation_x:Marker3D
var camera_rotation_y:Marker3D

var ray_cast:RayCast3D
var ray_cast_colliding_node:Node


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera_rotation_x = get_node("CameraPos/RotationY/RotationX")
	camera_rotation_y = $CameraPos/RotationY	# same as above
	ray_cast = $CameraPos/RotationY/RotationX/RayCast3D



func _input(event):         
	# click to capture mouse, escape to release
	if Input.is_action_just_pressed("focus"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if Input.is_action_just_pressed("unfocus"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			camera_rotation_y.rotate_y(-event.relative.x*mouse_sens)
			var rx=-event.relative.y*mouse_sens
			if camera_rotation_x.rotation.x + rx > -PI/2 and camera_rotation_x.rotation.x + rx < PI/2:
				camera_rotation_x.rotate_x(rx)

		if event.is_pressed() and event is InputEventMouseButton and ray_cast_colliding_node != null:
			if event.button_index == MOUSE_BUTTON_RIGHT:
				place_block.emit(ray_cast_colliding_node.position + ray_cast.get_collision_normal())
			if event.button_index == MOUSE_BUTTON_LEFT:
				mine_block.emit(ray_cast_colliding_node)


func _physics_process(delta):
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return

	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_a", "move_d", "move_w", "move_s")
	var direction = (camera_rotation_y.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

	# Without force update ray_cast.get_collider() will return null when block is destroyed
	# When using force update the RayCast3D node can be disabled
	ray_cast.force_raycast_update()

	if ray_cast.is_colliding():
		ray_cast_colliding_node = ray_cast.get_collider().get_node("..")
		highlight_block.emit(ray_cast_colliding_node.position, ray_cast.get_collision_normal())
	else:
		ray_cast_colliding_node = null
		highlight_block.emit(Vector3(), Vector3(), Color(0,0,0))
