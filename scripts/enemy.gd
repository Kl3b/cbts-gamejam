extends RigidBody2D

@export var fireRate : float = 2.5
@export var health : int = 100
@export var weaponDamage: int = 100
@export var bulletSpeed: float = 200
@onready var firePoint = $FirePointEnemy
@onready var fire_rate_timer = $FireRate

@onready var face_sprite = $FaceSprite

var bulletPrefab = preload("res://scenes/enemybullet.tscn")

var Player : Node
func _ready():
	#Get player from game manager
	Player = Gamemanager.Player
	#Connect to mode change signal
	#if Player:
		#Gamemanager.connect("control_mode_changed", _on_control_mode_changed)

func _physics_process(delta):
	spriteControl()
	if Player != null and Gamemanager.currentControlMode == Gamemanager.controlMode.TOP_DOWN:
		targetPlayer()

#Take damage and lose HP
func takeDamage(damage):
	health -= damage
	if health <= 0:
		die()

#Die, delete self
func die():
	queue_free()

#Shoot at the player
func targetPlayer():
	look_at(Player.position)
	if fire_rate_timer.is_stopped():
		shoot()

func shoot():
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
		fire_rate_timer.start()
		Gamemanager.bulletContainer.add_child(firedBullet)
		

#When changing to platformer mode become inactive
#func _on_control_mode_changed(_newControlMode):
	#if _newControlMode == Gamemanager.controlMode.PLATFORMER:
		#print("KILL MYSELF")
	#if _newControlMode == Gamemanager.controlMode.TOP_DOWN:
		#print("I SHOULD EXIST")
	#

func spriteControl():
	face_sprite.rotation = rotation * -1
