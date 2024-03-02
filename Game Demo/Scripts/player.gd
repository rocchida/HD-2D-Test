extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var playerBody = $"."
	
# _physics_process is a function provided by Godot. TLDR - It runs like once a frame
# I used this as a main method and broke down all logic into smaller functions for readability
func _physics_process(delta):
	handle_gravity_and_jumping(delta)
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	update_animations(input_dir)
	move_player(direction)
	move_and_slide()
			
func handle_gravity_and_jumping(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
func update_animations(direction):
	if (direction == Vector2.ZERO): 
		$AnimationTree.get("parameters/playback").travel("idle")
	else:
		$AnimationTree.get("parameters/playback").travel("walk")
		$AnimationTree.set("parameters/idle/blend_position", direction)
		$AnimationTree.set("parameters/walk/blend_position", direction)
	
func move_player(direction):
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
