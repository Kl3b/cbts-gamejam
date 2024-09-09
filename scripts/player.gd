extends CharacterBody2D



#Testing
@export var isPlatformerMode : bool = true
@export var isMouseMode : bool = true
#Character control
@export var fireRate : float = 0.2
@export var weaponDamage : int = 50
@export var bulletSpeed : int = 300
const SPEED = 300.0
const JUMP_VELOCITY = -400.0



@export_group("Movement Type")
@export var controlMode : int = 0

#Nodes/Scenes
@onready var firePoint = $FirePoint
@onready var fireRateTimer = $Timer
var bulletPrefab = preload("res://scenes/bullet.tscn")

func _ready():
	fireRateTimer.wait_time = fireRate



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
		isPlatformerMode = !isPlatformerMode
	if isPlatformerMode == true:
		platformer_mode(delta)
	if isPlatformerMode == false:
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

func platformer_mode(delta):
		# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Handle jump.

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
	bulletHellMovement(delta)
	shooting(delta)
	
func shooting(delta):
	if Input.is_action_pressed("shoot") and fireRateTimer.is_stopped():
		var firedBullet = bulletPrefab.instantiate()
		firedBullet.myDamage = weaponDamage
		firedBullet.global_position = firePoint.global_position
		firedBullet.global_rotation = firePoint.global_rotation
		
		var direction = Vector2.RIGHT.rotated(global_rotation)
		firedBullet.apply_impulse(direction * bulletSpeed)
		
		fireRateTimer.start()
		get_tree().root.add_child(firedBullet)
		
func bulletHellMovement(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	move_and_slide()
	
	if isMouseMode:
		look_at(get_global_mouse_position())
	else:
		var look_direction = Input.get_vector("look_left","look_right","look_up","look_down")
		if look_direction.length() > 0:
			rotation = look_direction.angle()
	
