extends Node2D
class_name EnemyBase

@export var bulletSpeed: float = 200
@export var health : int
@export var weaponDamage: int = 100
@export var fireRate: float = 2.5

var fire_rate_timer = Timer.new()

var currentHealth : int
var bulletPrefab = preload("res://scenes/enemybullet.tscn")

func _ready():
	fire_rate_timer.one_shot = true
	fire_rate_timer.wait_time = fireRate
	self.add_child(fire_rate_timer)

func takeDamage(dmg):
	health -= dmg
	print("my health is " + str(health))
	if health < currentHealth:
		die()

func die():
	queue_free()

func shoot(_firePoint : Node):
		#Instantiate a new bullet
		var firedBullet = bulletPrefab.instantiate()
		#Tell that bullet its damage, and ensure its firing from the right location
		firedBullet.myDamage = weaponDamage
		firedBullet.global_position = _firePoint.global_position
		firedBullet.global_rotation = _firePoint.global_rotation
			
		#Apply an impulse force in the bullets fired direction
		print(_firePoint)
		applyBulletForce(firedBullet, _firePoint)
			
		Gamemanager.bulletContainer.add_child(firedBullet)

func applyBulletForce(_firedBullet, _firePoint):
	pass

	
