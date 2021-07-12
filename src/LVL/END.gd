extends Control

onready var label = $Label2
onready var time = $Timer

func _process(delta):
	label.text = str("Time Remaining To Main Menu: ", int(time.time_left))

func _on_Timer_timeout():
	Transition.transition("res://src/Main Menu/MainMenu.tscn")
