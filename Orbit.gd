extends ImmediateGeometry


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#draw_orbit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func drawline(a, b):
	begin(Mesh.PRIMITIVE_LINES)
	set_color(Color( 0.75, 0.75, 0.75, 1))
	add_vertex(a)
	add_vertex(b)
	end()

func draw_points(points):
	begin(Mesh.PRIMITIVE_LINES)
	set_color(Color( 0.5, 0.5, 0.5, 1))
	var i = 0
	while i < (points.size()):
		set_normal(Vector3(1,0,0))
		set_uv(Vector2(0,0))
		add_vertex(points[i])
		
		set_normal(Vector3(1,0,0))
		set_uv(Vector2(0,0))
		if (i+1) == points.size():
			# the last point connects to the first point
			add_vertex(points[0])
		else:
			add_vertex(points[i+1])
		
		i += 1
	end()

func draw_orbit():
	var point_count = 64
	var points_arc = PoolVector3Array()
	
	var center = Vector3(0,0,0)
	var radius = 30
	var angle_from = 0
	var angle_to = 360
	
	for i in range(point_count + 1):
		# TODO: extend to ellipse; a, b params derived from eccentricity
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / point_count - 90)
		points_arc.push_back(center + Vector3(cos(angle_point), 0, sin(angle_point)) * radius)
		
	begin(Mesh.PRIMITIVE_LINES)
	set_color(Color( 0.5, 0.5, 0.5, 1))
	for i in range(point_count):
		set_normal(Vector3(1,0,0))
		set_uv(Vector2(0,0))
		add_vertex(points_arc[i])
		
		set_normal(Vector3(1,0,0))
		set_uv(Vector2(0,0))
		add_vertex(points_arc[i+1])
	end()
	
