extends Node

enum controlMode {TOP_DOWN, PLATFORMER}
var currentControlMode: int = controlMode.TOP_DOWN
var Player: Node
var PlayerHealth : int

signal control_mode_changed(newControlMode: controlMode)

func connectToPlayer():
	if Player:
		Player.connect("took_damage", updateHealth)

func _process(delta):
	if Input.is_action_just_pressed("swap"):
		print("swapping")
		currentControlMode = swapControlModes(currentControlMode)
		
func swapControlModes(_currentControlMode: controlMode):
	var _newControlMode
	if _currentControlMode == controlMode.TOP_DOWN:
		_newControlMode = controlMode.PLATFORMER
	else:
		_newControlMode = controlMode.TOP_DOWN
	control_mode_changed.emit(_newControlMode)
	return _newControlMode

func updateHealth(health):
	PlayerHealth = health
