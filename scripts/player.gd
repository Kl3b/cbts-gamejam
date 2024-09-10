extends CharacterBody2D



#Testing
@export var isMouseMode : bool = true
#Character control
@export var fireRate : float = 0.2
@export var weaponDamage : int = 50
@export var bulletSpeed : int = 300
@export var maxHealth : int = 100
var health : int
@export var topDownMoveSpeed = 300.0
const JUMP_VELOCITY = -400.0

signal took_damage(newHP: int)
signal player_ready()

@export_group("Jump Properties")
@export var jump_force : int = 1000
@export var gravity : float = 4000
@export var lowJumpMultiplier : float = 2
@export var fallMultiplier : float = 2.5

#Nodes/Scenes
@onready var firePoint = $FirePoint
@onready var fireRateTimer = $FireRateTimer
var bulletPrefab = preload("res://scenes/bullet.tscn")

# Celeste does accel = 10xmax speed, decel = 20x max speed, jump to 3x sprite height
@export_group("Movement Properties")
@export var acceleration : float = 5000
@export var deceleration : float = 10000
@export var top_speed : float = 500



@export var coyoteTime : float = 2.0
@onready var coyote_timer = $CoyoteTimer
var has_jumped : bool = false

@export var jumpBufferTime : float = 0.1
@onready var jump_buffer_timer = $JumpBufferTimer

#Sprites
@onready var face_sprite = $FaceSprite
@onready var hand_sprite = $HandSprite

func _ready():
	fireRateTimer.wait_time = fireRate
	coyote_timer.wait_time = coyoteTime
	jump_buffer_timer.wait_time = jumpBufferTime
	Gamemanager.connect("control_mode_changed", on_control_mode_change)
	Gamemanager.Player = self
	Gamemanager.connectToPlayer()
	Gamemanager.PlayerHealth = maxHealth
	health = maxHealth
	match Gamemanager.currentControlMode:
		Gamemanager.controlMode.TOP_DOWN:
			face_sprite.frame = 2
		Gamemanager.controlMode.PLATFORMER:
			face_sprite.frame = 0

func _physics_process(delta):
	if Gamemanager.currentControlMode == Gamemanager.controlMode.PLATFORMER:
		platformer_mode(delta)
	if Gamemanager.currentControlMode == Gamemanager.controlMode.TOP_DOWN:
		bullethell_mode(delta)
		

func on_control_mode_change(controlMode: Gamemanager.controlMode):
	#reset all coyote/buffer timers to avoid issues
	if controlMode == Gamemanager.controlMode.PLATFORMER:
		coyote_timer.stop()
		jump_buffer_timer.stop()
		#print("reset rotation")
		rotation = 0
		face_sprite.rotation = 0
	if controlMode == Gamemanager.controlMode.TOP_DOWN:
		face_sprite.frame = 2


func platformer_mode(delta):
	platformerMovement(delta)
	

func platformerMovement(delta):
	#Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		face_sprite.frame = 1
	#We are on the floor, therefore we reset the coyote timer running and check for buffered jumps
	else:
		face_sprite.frame = 0
		coyote_timer.start()
		#If there has been a jump input in the last bufferTime seconds, we will jump
		if not jump_buffer_timer.is_stopped():
			jump()
			jump_buffer_timer.stop()
	
	#Check for jump input
	if Input.is_action_just_pressed("jump"):
		#Start the buffer timer when jump is input
		jump_buffer_timer.start()
		if can_jump():
			jump()
	
	if velocity.y > 0:
		# If we are moving downwards
		velocity.y += gravity * (fallMultiplier) * delta
	elif velocity.y < 0 and not Input.is_action_pressed("jump"):
		# if we are moving upwards and not holding jump, turn up gravity.
		velocity.y += gravity * (lowJumpMultiplier) * delta
	
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
	
#Jump function, stop the coyote timer after we've jumped.
func jump():
	velocity.y = -jump_force
	coyote_timer.stop()

#Function to check if we can jump
func can_jump():
	#If we are on the floor we can perform a normal jump
	if is_on_floor():
		return true
	#If we're not on the floor, but the coyote timer is running, we can coyote jump
	elif not coyote_timer.is_stopped() and not is_on_floor():
		return true
	#If none of the above is true we can't jump
	return false

func bullethell_mode(delta):
	bulletHellMovement(delta)
	shooting(delta)
	
func shooting(delta):
	#Check for shooting input
	if Input.is_action_pressed("shoot") and fireRateTimer.is_stopped():
		#Instantiate a new bullet
		var firedBullet = bulletPrefab.instantiate()
		#Tell that bullet its damage, and ensure its firing from the right location
		firedBullet.myDamage = weaponDamage
		firedBullet.global_position = firePoint.global_position
		firedBullet.global_rotation = firePoint.global_rotation
		
		#Apply an impulse force in the bullets fired direction
		var direction = Vector2.RIGHT.rotated(global_rotation)
		firedBullet.apply_impulse(direction * bulletSpeed)
		
		#Start timer for fire rate
		fireRateTimer.start()
		Gamemanager.bulletContainer.add_child(firedBullet)
		
var center_point = position
var radius = 40

func bulletHellMovement(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction:
		velocity = (direction * topDownMoveSpeed)
	else:
		velocity.x = move_toward(velocity.x, 0, topDownMoveSpeed)
		velocity.y = move_toward(velocity.y, 0, topDownMoveSpeed)
	move_and_slide()
	
	if isMouseMode:
		look_at(get_global_mouse_position())
	else:
		var look_direction = Input.get_vector("look_left","look_right","look_up","look_down")
		if look_direction.length() > 0:
			rotation = look_direction.angle()
	spriteControl()
	
func takeDamage(dmg: int):
	health -= dmg
	took_damage.emit(health)
	if health < maxHealth:
		die()

signal player_died()
func die():
	player_died.emit()
	#death stuff goes here
	queue_free()
	
func spriteControl():
	face_sprite.rotation = rotation * -1
	
signal collected_bonus_coin()
func collectBonusCoin():
	print("collected bonus coin")
	collected_bonus_coin.emit()
