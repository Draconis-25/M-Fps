extends Spatial



func _on_Area_body_entered(body):
	if body is Player:
		Transition.transition("res://src/LVL/END.tscn")
