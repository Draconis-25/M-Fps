extends Node

var player

var mode : bool = true
var w_visible : bool = false

func _process(_delta):
	if Input.is_action_just_pressed("wshow"):
		w_visible = !w_visible
