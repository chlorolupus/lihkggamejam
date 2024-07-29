extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var WorldPos = get_node("Camera3D").project_position(get_viewport().get_mouse_position(), 0.0)
	get_node("RayCast3D").transform.origin = WorldPos
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		get_node("RayCast3D").get_collider().get_parent().mesh.material.albedo_color = Color.RED
	pass
