extends CanvasLayer

@onready var switch_timer = $SwitchTimer


func _ready():
	switch_timer.max_value = Gamemanager.switchTime
	
func _process(delta):
	switch_timer.value = Gamemanager.switchTimer.time_left
	if Gamemanager.currentControlMode == Gamemanager.controlMode.TOP_DOWN:
		switch_timer.tint_progress = Color("Green")
	if Gamemanager.currentControlMode == Gamemanager.controlMode.PLATFORMER:
		switch_timer.tint_progress = Color("Red")
