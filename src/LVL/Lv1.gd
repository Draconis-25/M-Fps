extends Spatial



func _on_Area2_body_entered(body):
	if body is Player:
		Transition.transition("res://src/LVL/Lv2.tscn")
