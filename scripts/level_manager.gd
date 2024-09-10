extends Node

var currentLevel = null
#var levels = {
	#"level1": preload("res://levels/leveltest.tscn"),
	#"level2": preload("res://levels/testlevel_2.tscn"),
	#"level3": preload("res://levels/leveltest_2.tscn"),
#}

var levels : Array[PackedScene]

func _ready():
	loadLevels("res://levels/")
	var _root = get_tree().root 
	currentLevel = _root.get_child(_root.get_child_count() - 1)
	print(currentLevel)
		
func loadLevels(_path : String):
	var _dir = DirAccess.open(_path)
	if _dir:
		_dir.list_dir_begin()
		var _fileName = _dir.get_next()
		while _fileName != "":
			if _fileName.ends_with(".tscn"):
				var _scene = load(_path.path_join(_fileName))
				if _scene is PackedScene:
					levels.append(_scene)
			_fileName = _dir.get_next()
	else:
		printerr("Couldn't find levels folder!")
	print("loaded " + str(levels.size()) + "levels")
	
	#I'm not sure if this is the right way of doing this but it seems to work
	#We can store metadata on a level scenes root node to access data about the level easily
	#We just have to make a temporary instance of the level to access the metadata
	#for _level in levels:
		#var _temp = _level.instantiate()
		#print(_temp.get_meta("level_name"))
		#_temp.free()


func goToLevel(_newLevel : int):
	call_deferred("defGoToLevel", _newLevel)

func defGoToLevel(_newLevel : int):
	currentLevel.free()
	var _level = levels[_newLevel-1]
	currentLevel = _level.instantiate()
	get_tree().root.add_child(currentLevel)
	Gamemanager.CurrentLevel = currentLevel
	Gamemanager.createBulletContainer()

func getLevelNumber(_currentLevel):
	if _currentLevel.is_in_group("level"):
		var _levelNo = _currentLevel.get_meta("level_number")
		return _levelNo
	else:
		return
