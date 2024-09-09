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
#Nodes/Scenes
@onready var firePoint = $FirePoint
@onready var fireRateTimer = $Timer
var bulletPrefab = preload("res://scenes/bullet.tscn")

func _ready():
	fireRateTimer.wait_time = fireRate

func _physics_process(delta):
	if Input.is_action_just_pressed("swap"):
		isPlatformerMode = !isPlatformerMode
	if isPlatformerMode == true:
		platformer_mode(delta)
	if isPlatformerMode == false:
		bullethell_mode(delta)
	
func platformer_mode(delta):
		# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
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
		
