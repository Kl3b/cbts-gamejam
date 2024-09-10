extends Node2D
class_name EnemyBase

@export var health : int
var currentHealth : int

func takeDamage(dmg):
	health -= dmg
	if health < currentHealth:
		die()

func die():
	queue_free()
