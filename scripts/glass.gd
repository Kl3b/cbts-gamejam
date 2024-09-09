extends StaticBody2D

func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("player"):
		var speed = body.get_real_velocity().y
		if speed > 1000:
			print(speed)
			queue_free()
