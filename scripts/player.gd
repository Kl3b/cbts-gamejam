extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var controlMode : int = 0

func _physics_process(delta):
	if Input.is_action_just_pressed("swap"):
		controlMode = 1
	if controlMode == 0:
		platformer_mode(delta)
	if controlMode == 1:
		bullethell_mode(delta)
	
	
func platformer_mode(delta):
		# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		print(get_gravity())
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("left", "right", "down", "up")
	if direction:
		velocity.x = direction.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func bullethell_mode(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	print(direction)
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	move_and_slide()
