extends Area



func _on_Deadline_body_entered(body):
	if body is Player:
		get_tree().reload_current_scene()
