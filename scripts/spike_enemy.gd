extends EnemyBase

func _on_body_entered(body):
	print("spike enemy collision")
	if body.is_in_group("player"):
		body.die()
