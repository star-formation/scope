extends MeshInstance


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	apply_texture(self, "res://2k_mars.jpg")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func apply_texture(mesh_instance_node, texture_path):
	var texture = ImageTexture.new()
	var image = Image.new()
	image.load(texture_path)
	texture.create_from_image(image)
	if mesh_instance_node.material_override:
		mesh_instance_node.material_override.albedo_texture = texture
