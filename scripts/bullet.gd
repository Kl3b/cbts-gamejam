extends RigidBody2D

var myDamage 

func _on_timer_timeout():
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("enemy"):
		body.takeDamage(myDamage)
		queue_free()
	elif !body.is_in_group("bullet"):
		queue_free()
