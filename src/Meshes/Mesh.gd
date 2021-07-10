extends Spatial

var mat = preload("res://src/Meshes/mesh.tres")
var tmat = preload("res://src/Meshes/mesh-t.tres")

onready var collision =  $StaticBody/CollisionShape

func _process(_delta):
	if Global.mode:
		$Mesh.set_surface_material(mat)
	else:
		$Mesh.set_surface_material(tmat)
	
	collision.disabled = !Global.mode
