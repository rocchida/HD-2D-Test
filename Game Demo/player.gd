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
	if direction == Vector2(0,0):
		$AnimationPlayer.stop()
	choose_animation(direction)
	
func choose_animation(input_dir):
	if input_dir.x == 1 and input_dir.y == 0:	$AnimationPlayer.play("walk_east")
	if input_dir.x == -1 and input_dir.y == 0:	$AnimationPlayer.play("walk_west")
	if input_dir.x == 0 and input_dir.y == 1:	$AnimationPlayer.play("walk_south")
	if input_dir.x == 0 and input_dir.y == -1:	$AnimationPlayer.play("walk_north")
	if input_dir.x > 0 and input_dir.y > 0:		$AnimationPlayer.play("walk_southeast")
	if input_dir.x > 0 and input_dir.y < 0:		$AnimationPlayer.play("walk_northeast")
	if input_dir.x < 0 and input_dir.y > 0:		$AnimationPlayer.play("walk_southwest")
	if input_dir.x < 0 and input_dir.y < 0:		$AnimationPlayer.play("walk_northwest")
	
func move_player(direction):
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
