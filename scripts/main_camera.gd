extends Node3D

@export var speed = 500
var rotation_angle = Global.rotation_angle
@onready var node = $"."
@onready var cam = $Camera3D
@onready var sun = $"../Sun"
var x = 0
var y = 0
var z = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cam.make_current()
	pass
	
var rot_x = 0
var rot_y = PI / 2

func _input(event):
	if event is InputEventMouseMotion and event.button_mask & 1:
		# modify accumulated mouse rotation
		rot_x += event.relative.x * rotation_angle
		rot_y += event.relative.y * rotation_angle
		transform.basis = Basis() # reset rotation
		rotate_object_local(Vector3(0, -1, 0), rot_x) # first rotate in Y
		rotate_object_local(Vector3(-1, 0, 0), rot_y) # then rotate in X
		
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var forward = node.transform.basis.z.normalized()
	var right = -node.transform.basis.x.normalized()  
	var up = node.transform.basis.y.normalized()     

	var move_direction = Vector3.ZERO
	const boost = 50
	const slow = 0.25

		

	if Input.is_physical_key_pressed(KEY_W):
		move_direction += forward
	if Input.is_physical_key_pressed(KEY_S):
		move_direction -= forward
	if Input.is_physical_key_pressed(KEY_A):
		move_direction -= right
	if Input.is_physical_key_pressed(KEY_D):
		move_direction += right
	if Input.is_physical_key_pressed(KEY_SPACE):
		move_direction -= up
	if Input.is_physical_key_pressed(KEY_SHIFT):
		move_direction += up
		
	if Input.is_physical_key_pressed(KEY_CTRL):
		move_direction *= boost
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		move_direction *= slow	
		
	node.position += -move_direction * speed 
	
	#print(cam.position)
func cameraPosition(p:RigidBody3D):
	var pos = (sun.position - p.position).normalized()
	var offset =  p.get_child(0).scale + Vector3(100,0,-140)
	cam.position = p.position - pos 
