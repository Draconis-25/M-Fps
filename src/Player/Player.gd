extends KinematicBody
class_name Player

const ACCEL_DEFAULT = 7
const ACCEL_AIR = 1
onready var accel = ACCEL_DEFAULT

export var speed = 7
export var gravity = 30
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
var snap

var direction = Vector3()
var velocity = Vector3()
var gravity_vec = Vector3()
var movement = Vector3()

onready var head = $Head
onready var camera = $Head/Camera
onready var timer = $Timer
onready var change_bar = $GUI/ChangeBar
onready var health_bar = $GUI/HealthBar
onready var ability_bar = $GUI/AbilityBar

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
	health_bar.value = health
	ability_bar.value =ability


func _physics_process(delta):
	#get keyboard input
	direction = Vector3.ZERO
	var h_rot = global_transform.basis.get_euler().y
	var f_input = Input.get_action_strength("backward") - Input.get_action_strength("forward")
	var h_input = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction = Vector3(h_input, 0, f_input).rotated(Vector3.UP, h_rot).normalized()
	
	#jumping and gravity
	if is_on_floor():
		snap = -get_floor_normal()
		accel = ACCEL_DEFAULT
		gravity_vec = Vector3.ZERO
	else:
		snap = Vector3.DOWN
		accel = ACCEL_AIR
		gravity_vec += Vector3.DOWN * gravity * delta
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		snap = Vector3.ZERO
		gravity_vec = Vector3.UP * jump
		jump_num = 1
	
	match avalue:
		0:
			double_jump()
		1:
			blink()
	#make it move
	velocity = velocity.linear_interpolate(direction * speed, accel * delta)
	movement = velocity + gravity_vec
	
	move_and_slide_with_snap(movement, snap, Vector3.UP)

func _on_Timer_timeout():
	Global.mode = !Global.mode
	avalue = randi()%2
	print(avalue)
	
func double_jump():
	if Input.is_action_just_pressed("jump") and not is_on_floor():
		if jump_num == 1:
			snap = Vector3.ZERO
			gravity_vec = Vector3.UP * jump
			jump_num = 0


func blink():
	if Input.is_action_just_pressed("lmb"):
		direction *= blink_dist

