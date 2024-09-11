extends Node2D

@onready var door : Node = $OpenableDoor
@onready var button : Node = $door_button

func _ready():
	button.connect("button_pressed", buttonPressed)
	
func buttonPressed():
	door.doorOpened()
