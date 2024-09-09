extends RigidBody2D

var myDamage 

func _on_timer_timeout():
	queue_free()


func _on_body_entered(body):
	print("collided")
	if body.is_in_group("enemy"):
		print("collided with enemy")
		body.takeDamage(myDamage)
		queue_free()
	elif !body.is_in_group("bullet"):
		print("collided with else")
		queue_free()
