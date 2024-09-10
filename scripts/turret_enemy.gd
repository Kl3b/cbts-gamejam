extends EnemyBase

@export var shootUp : bool
@export var shootDown : bool
@export var shootLeft : bool
@export var shootRight : bool

@onready var firePointUp = $FirePointUp
@onready var firePointDown = $FirePointDown
@onready var firePointLeft = $FirePointLeft
@onready var firePointRight = $FirePointRight

var firePoints : Array[Node]

func _ready():
	super()
	if shootUp == true:
		firePoints.append(firePointUp)
	if shootDown == true:
		firePoints.append(firePointDown)
	if shootLeft == true:
		firePoints.append(firePointLeft)
	if shootRight == true:
		firePoints.append(firePointRight)

func _process(delta):
	if Gamemanager.currentControlMode == Gamemanager.controlMode.TOP_DOWN:
		if fire_rate_timer.is_stopped():
			for _firePoint in firePoints:
				shoot(_firePoint)
			fire_rate_timer.start()

func applyBulletForce(_firedBullet, _firePoint):
	var _direction = Vector2.RIGHT.rotated(_firePoint.global_rotation)
	_firedBullet.apply_impulse(_direction * bulletSpeed)
