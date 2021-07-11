extends Spatial

export(int, 1, 2) var type = 1

export var mat = preload("res://res/Greengrid.tres")
export var tmat = preload("res://res/Redgrid.tres")

onready var collision =  $StaticBody/CollisionShape

func _process(_delta):
	if Global.mode:
		if type == 1:
			$Mesh.set_surface_material(0, mat)
			collision.disabled = false
		else:
			$Mesh.set_surface_material(0, tmat)
			collision.disabled = true
	else:
		if type == 1:
			$Mesh.set_surface_material(0, tmat)
			collision.disabled = true
		else:
			$Mesh.set_surface_material(0, mat)
			collision.disabled = false

