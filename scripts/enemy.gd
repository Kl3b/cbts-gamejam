extends RigidBody2D

@export var health : int = 100

func takeDamage(damage):
	print("took damage, my health is " + str(health))
	health -= damage
	if health <= 0:
		die()
func die():
	print(str(self) + "died")
	queue_free()
	
