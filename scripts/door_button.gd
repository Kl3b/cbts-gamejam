extends Node2D


signal button_pressed()
func _on_body_entered(body):
	print("button collided")
	if body.is_in_group("player") and Gamemanager.currentControlMode == Gamemanager.controlMode.PLATFORMER:
		print("the button was pressed!")
		button_pressed.emit()
		queue_free()
