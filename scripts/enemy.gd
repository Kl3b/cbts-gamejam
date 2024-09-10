extends EnemyBase

@onready var face_sprite = $FaceSprite
@onready var firePoint = $FirePointEnemy


var Player : Node
func _ready():
	super()
	#Get player from game manager
	Player = Gamemanager.Player
	#Connect to mode change signal
	#if Player:
		#Gamemanager.connect("control_mode_changed", _on_control_mode_changed)

func _physics_process(delta):
	spriteControl()
	if Player != null and Gamemanager.currentControlMode == Gamemanager.controlMode.TOP_DOWN:
		targetPlayer()

#Shoot at the player
func targetPlayer():
	look_at(Player.position)
	if fire_rate_timer.is_stopped():
		shoot(firePoint)
		fire_rate_timer.start()

func applyBulletForce(_firedBullet, _firePoint):
	var direction = Vector2.RIGHT.rotated(global_rotation)
	_firedBullet.apply_impulse(direction * bulletSpeed)


#When changing to platformer mode become inactive
#func _on_control_mode_changed(_newControlMode):
	#if _newControlMode == Gamemanager.controlMode.PLATFORMER:
		#print("KILL MYSELF")
	#if _newControlMode == Gamemanager.controlMode.TOP_DOWN:
		#print("I SHOULD EXIST")
	

func spriteControl():
	face_sprite.rotation = rotation * -1
