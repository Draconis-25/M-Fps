extends Control

onready var howto = $Control2

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_Play_pressed():
	get_tree().change_scene("res://src/LVL/Lv1.tscn")


func _on_Howto_pressed():
	howto.visible = !howto.visible

func _on_Quit_pressed():
	get_tree().quit()
