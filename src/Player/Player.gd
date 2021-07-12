extends KinematicBody
class_name Player

var speed = 7
var acceleration = 10
var gravity = 0.09
export var jump = 10
var jump_num = 0
var blink_dist = 25
var wall_normal
var w_runnable = false

var avalue : int

var health = 100
var ability = 50

export var cam_accel = 40
export var sensitivity = 0.5


var direction = Vector3()
var velocity = Vector3()
var fall = Vector3() 


onready var head = $Head
onready var camera = $Head/Camera
onready var timer = $Timer
onready var change_bar = $GUI/ChangeBar
#onready var health_bar = $GUI/HealthBar
#onready var ability_bar = $GUI/AbilityBar

func _ready():
	#hides the cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Global.player = self
	avalue = randi()%2
	print(avalue)

func _input(event):
	#get mouse input for camera rotation
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))

func _process(delta):
	#camera physics interpolation to reduce physics jitter on high refresh-rate monitors
	if Engine.get_frames_per_second() > Engine.iterations_per_second:
		camera.set_as_toplevel(true)
		camera.global_transform.origin = camera.global_transform.origin.linear_interpolate(head.global_transform.origin, cam_accel * delta)
		camera.rotation.y = rotation.y
		camera.rotation.x = head.rotation.x
	else:
		camera.set_as_toplevel(false)
		camera.global_transform = head.global_transform

	change_bar.value = timer.time_left *2

func _physics_process(delta):
		
	direction = Vector3()
						
	move_and_slide(fall, Vector3.UP)
	
	if not is_on_floor():
		fall.y -= gravity
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		fall.y = jump
		jump_num = 1
	
	match avalue:
		0:
			double_jump()
		1:
			blink()
	
	wall_run()
		
	if Input.is_action_pressed("move_forward"):
			
			direction -= transform.basis.z
		
	elif Input.is_action_pressed("move_backward"):
			
		direction += transform.basis.z
							
	if Input.is_action_pressed("move_left"):
		
		direction -= transform.basis.x			
		
	elif Input.is_action_pressed("move_right"):
						
		direction += transform.basis.x
			
		
	direction = direction.normalized()
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta) 
	velocity = move_and_slide(velocity, Vector3.UP) 


func _on_Timer_timeout():
	Global.mode = !Global.mode
	avalue = randi()%2
	print(avalue)
	
func double_jump():
	if Input.is_action_just_pressed("jump") and not is_on_floor():
		if jump_num == 1:
			fall.y = jump
			jump_num = 0

func blink():
	if Input.is_action_just_pressed("lmb"):
		direction *= blink_dist

func wall_run():
	if w_runnable:		
		if Input.is_action_pressed("jump"):	
			if Input.is_action_pressed("move_forward"):
				if is_on_wall():
					wall_normal = get_slide_collision(0)
					yield(get_tree().create_timer(0.2), "timeout")
					fall.y = 0
					direction = -wall_normal.normal * speed


