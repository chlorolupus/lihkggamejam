extends Node3D


enum Building {Food, Bonfire, Population, Strength}

var IsDragging : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var WorldPos = get_node("Camera3D").project_position(get_viewport().get_mouse_position(), 0.0)
	get_node("RayCast3D").transform.origin = WorldPos
	if IsDragging:
		get_node("Card").transform.origin = WorldPos
		#get_node("Card").transform.origin.x += 1.0
		get_node("Card").transform.origin.z += 0.5
	
	#get_node("Card").look_at(get_node("Camera3D").transform.origin)
	for node in get_node("VillageA").get_children():
		if node is MeshInstance3D:
			node.mesh.material.albedo_color = Color.WHITE
	for node in get_node("VillageB").get_children():
		if node is MeshInstance3D:
			node.mesh.material.albedo_color = Color.WHITE
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if IsDragging:
			get_node("Card").modulate = Color(1, 1, 1, 0.5)
		if get_node("RayCast3D").get_collider() is StaticBody3D and get_node("RayCast3D").get_collider().get_parent() is MeshInstance3D:
			get_node("RayCast3D").get_collider().get_parent().mesh.material.albedo_color = Color.RED
			pass
		if get_node("RayCast3D").get_collider() is StaticBody3D and get_node("RayCast3D").get_collider().get_parent() is Sprite3D:
			IsDragging = true
	elif IsDragging and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		IsDragging = false
		if get_node("RayCast3D").get_collider() is StaticBody3D and get_node("RayCast3D").get_collider().get_parent() is MeshInstance3D:
			get_node("RayCast3D").get_collider().get_parent().get_node("Hut").visible = true
			pass
	else:
		IsDragging = false
		get_node("Card").transform.origin = Vector3(-2.7, -0.83, -2.1)
	pass
