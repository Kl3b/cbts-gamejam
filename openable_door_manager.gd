extends Node2D

@export var door : Node
@export var button : Node

func _ready():
	button.connect("button_pressed", buttonPressed)
	
func buttonPressed():
	door.doorOpened()
