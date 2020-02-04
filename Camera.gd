extends Camera

# settings
export (float, 0.0, 1.0) var sensitivity = 0.5
export (float, 0.0, 0.999, 0.001) var smoothness = 0.5 setget set_smoothness
export(NodePath) var privot setget set_privot
export var distance = 5.0 setget set_distance
export (int, 0, 360) var yaw_limit = 360
export (int, 0, 360) var pitch_limit = 360

export var zoomStep = 0.2
export var default_distance = 6.0

# internal variables
var _yaw = 0.0
var _pitch = 0.0
var _total_yaw = 0.0
var _total_pitch = 0.0
var _mouse_pos = Vector2(0.0,0.0)
var _camera_drag = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _input_event(event):
	pass
	
	#if event is InputEventMouseButton:
	#	if event.button_index == BUTTON_LEFT:
	#		_camera_drag = event.pressed

func _input(event):
	if event is InputEventMouseMotion:
		if _camera_drag:
			_mouse_pos = event.relative

	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			_camera_drag = event.pressed
		elif event.button_index == BUTTON_WHEEL_UP:
			distance -= zoomStep
		elif event.button_index == BUTTON_WHEEL_DOWN:
			distance += zoomStep
		#elif event.button_index == BUTTON_MIDDLE:
		#	distance = default_distance

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	_update_distance()
	_update_view()

func _update_process_func():
	set_process(true)

func _update_view():
	_yaw = _yaw * smoothness + _mouse_pos.x * sensitivity * (1.0 - smoothness)
	_pitch = _pitch * smoothness + _mouse_pos.y * sensitivity * (1.0 - smoothness)
	_mouse_pos = Vector2(0.0,0.0)
	
	if yaw_limit < 360:
		_yaw = clamp(_yaw, -yaw_limit - _total_yaw, yaw_limit - _total_yaw)
	if pitch_limit < 360:
		_pitch = clamp(_pitch, -pitch_limit - _total_pitch, pitch_limit - _total_pitch)
		
	_total_yaw += _yaw
	_total_pitch += _pitch
	
	var target = privot.get_translation()
	var offset = get_translation().distance_to(target)
	
	set_translation(target)
	rotate_y(deg2rad(-_yaw))
	rotate_object_local(Vector3(1.0,0.0,0.0), deg2rad(-_pitch))
	translate(Vector3(0.0,0.0,offset))
	
func _update_distance():
	var t = privot.get_translation()
	t.z -= distance
	set_translation(t)

func set_privot(value):
	privot = value
	_update_process_func()

func set_smoothness(value):
	smoothness = clamp(value, 0.001, 0.999)
	
func set_distance(value):
	distance = max(0, value)
