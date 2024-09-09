extends Node

enum controlMode {TOP_DOWN, PLATFORMER}
var currentControlMode: int = controlMode.PLATFORMER
var Player: Node
var PlayerHealth : int

var switchTime = 3
var timer = Timer.new()
var bonusCoinsCollected : int


signal control_mode_changed(newControlMode: controlMode)


func connectToPlayer():
	if Player:
		Player.connect("took_damage", updateHealth)
		Player.connect("collected_bonus_coin", updateCoins)
	
	timer.one_shot = true
	self.add_child(timer)
	timer.start(switchTime)


		

func _process(delta):
	#print(timer.time_left)
	if Input.is_action_just_pressed("swap"):
		currentControlMode = swapControlModes(currentControlMode)
	if timer.time_left == 0:
		currentControlMode = swapControlModes(currentControlMode)
		timer.start(3)
		
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

	
func _on_timer_timeout():
	print("timeout")



	


func updateCoins():
	bonusCoinsCollected += 1
	print(bonusCoinsCollected)
