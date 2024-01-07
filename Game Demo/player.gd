extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var playerBody = $"."
	
# _physics_process is a function provided by Godot. TLDR - It runs like once a frame
# I used this as a main method and broke down all logic into smaller functions for readability
func _physics_process(delta):
	handle_gravity_and_jumping(delta)
	var direction = get_directions_from_inputs()
	change_physics_and_animations_from_directions(direction)
	move_and_slide()

# For having mouse movements rotate the character. Click on game screen to turn this on and press escape to turn off.
# I got this function from this tutorial at 9:40: https://www.youtube.com/watch?v=v4IEPi1c0eE
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.mouse_mode = (Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = (Input.MOUSE_MODE_VISIBLE)
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED && event is InputEventMouseMotion:
			playerBody.rotate_y(-event.relative.x * 0.01)
			
func handle_gravity_and_jumping(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
func get_directions_from_inputs():
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	print("Input Dir: ", input_dir)
	print("Direction: ", direction)
	return direction
	
func change_physics_and_animations_from_directions(direction):
	if direction:
		$AnimationPlayer.play("walk")
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		$AnimationPlayer.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
