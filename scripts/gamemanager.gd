extends Node

enum controlMode {TOP_DOWN, PLATFORMER}
var currentControlMode: int = controlMode.PLATFORMER
var Player: Node
var PlayerHealth : int
var CurrentLevel : Node
var CurrentLevelNumber : int
var CompletedLevels : Array[int]

var PlayerScn = preload("res://scenes/player.tscn")

var switchTime = 3
var switchTimer = Timer.new()
var bonusCoinsCollected : int

signal control_mode_changed(newControlMode: controlMode)


func connectToPlayer():
	if Player:
		Player.connect("took_damage", updateHealth)
		Player.connect("collected_bonus_coin", updateCoins)
		Player.connect("player_died", playerDied)
	

func _ready():
	CurrentLevelNumber = 1
	getLevelData()
	createBulletContainer()
	self.add_child(switchTimer)
	swapTimer()

func getLevelData():
	CurrentLevel = LevelManager.currentLevel
	print(CurrentLevel)
	print(LevelManager.currentLevel)
	if LevelManager.currentLevel.is_in_group("level"):
		CurrentLevelNumber = LevelManager.getLevelNumber(LevelManager.currentLevel)

var bulletContainer : Node2D
func createBulletContainer():
	bulletContainer = Node2D.new()
	bulletContainer.name = "BulletContainer"
	CurrentLevel.add_child(bulletContainer)

func swapTimer():
	switchTimer.one_shot = true
	switchTimer.start(switchTime)

func _process(delta):
	#print(timer.time_left)
	if Input.is_action_just_pressed("swap"):
		currentControlMode = swapControlModes(currentControlMode)
	if switchTimer.time_left == 0:
		currentControlMode = swapControlModes(currentControlMode)
		switchTimer.start(3)
		
func swapControlModes(_currentControlMode: controlMode):
	var _newControlMode
	if _currentControlMode == controlMode.TOP_DOWN:
		clearAllBullets()
		_newControlMode = controlMode.PLATFORMER
	else:
		_newControlMode = controlMode.TOP_DOWN
	control_mode_changed.emit(_newControlMode)
	return _newControlMode

func updateHealth(health):
	PlayerHealth = health

func _on_timer_timeout():
	print("timeout")

func playerDied():
	LevelManager.goToLevel(CurrentLevelNumber)
	swapTimer()
	currentControlMode = controlMode.PLATFORMER

func updateCoins():
	bonusCoinsCollected += 1
	print(bonusCoinsCollected)


func exitReached():
	CompletedLevels.append(CurrentLevelNumber)
	CurrentLevelNumber += 1
	currentControlMode = controlMode.PLATFORMER
	LevelManager.goToLevel(CurrentLevelNumber)

func clearAllBullets():
	if bulletContainer:
		for bullet in bulletContainer.get_children():
			bullet.queue_free()
