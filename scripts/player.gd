extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


@export_group("Movement Type")
@export var controlMode : int = 0


# Celeste does accel = 10xmax speed, decel = 20x max speed, jump to 3x sprite height
@export_group("Movement Properties")
@export var acceleration : float = 5000
@export var deceleration : float = 10000
@export var top_speed : float = 500
@export var jump_force : int
@export var gravity : float = 50
var lowJumpMultiplier : float = 3
var fallMultiplier : float = 3

var coyoteTime : float = 2.0
var coyoteTimer : float = 2.0
var has_jumped : bool = false


func _physics_process(delta):
	if Input.is_action_just_pressed("swap"):
		controlMode = 1
	if controlMode == 0:
		platformer_mode(delta)
	if controlMode == 1:
		bullethell_mode(delta)
	
func can_jump(delta):
	if is_on_floor():
		has_jumped = false
		coyoteTimer = coyoteTime
		return true
	elif coyoteTimer > 0 and not has_jumped:
		coyoteTimer -= delta
		return true
	else:
		return false
		
	
func platformer_mode(delta):
	# Handle falling
	velocity.y += gravity * delta

	# All of this handles jumping. I don't like it at the moment.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_force
		has_jumped = true

	if velocity.y < 0:
		# If we are moving upwards
		velocity.y += gravity * (fallMultiplier - 1) * delta

	elif velocity.y > 0 and not Input.is_action_pressed("jump"):
		# if we are moving downwards and not holding jump?
		velocity.y += gravity * (lowJumpMultiplier-1) * delta
	
	# Get user input
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_vector("left", "right", "down", "up").x
	
	# Handle horizonal movement
	if input_vector.x != 0:
		velocity.x += input_vector.x * acceleration * delta
		velocity.x = clamp(velocity.x, -top_speed, top_speed)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)	

	move_and_slide()
	
#func can_jump():
	
#func jump(_delta)

func bullethell_mode(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	print(direction)
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	move_and_slide()
