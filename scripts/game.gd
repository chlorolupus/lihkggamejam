extends Node2D

var MoveSpeed = 450.0

var can_start : bool = false
var pair : Array[bool] = [false]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for Saw in get_tree().get_nodes_in_group("spin"):
		Saw.rotation += 20 * delta
	
	for Saw1 in get_tree().get_nodes_in_group("pair0"):
		if Saw1.collision_layer > 1:
			Saw1.modulate.a = 0.0
	if not pair[0]:
		for Saw1 in get_tree().get_nodes_in_group("pair0"):
			if Saw1.collision_layer > 1:
				Saw1.modulate.a = 0.5
	
	get_node("RayCast2D").position = get_global_mouse_position()
	if get_node("RayCast2D").get_collider() != null and get_node("RayCast2D").get_collider().has_node("CollisionPolygon2D") and get_node("RayCast2D").get_collider().collision_layer > 1 and not pair[0]:
		#get_node("RayCast2D").get_collider().modulate.a = 0.75
		get_node("RayCast2D").get_collider().get_parent().get_parent().get_node("Left").get_child(get_node("RayCast2D").get_collider().get_index()).modulate.a = 0.75
		get_node("RayCast2D").get_collider().get_parent().get_parent().get_node("Right").get_child(get_node("RayCast2D").get_collider().get_index()).modulate.a = 0.75
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if get_node("RayCast2D").get_collider() != null and get_node("RayCast2D").get_collider().has_node("CollisionPolygon2D") and not pair[0]:
			#get_node("RayCast2D").get_collider().collision_layer = 1
			#get_node("RayCast2D").get_collider().collision_mask = 1
			#get_node("RayCast2D").get_collider().modulate.a = 1.0
			get_node("RayCast2D").get_collider().get_parent().get_parent().get_node("Left").get_child(get_node("RayCast2D").get_collider().get_index()).collision_layer = 1
			get_node("RayCast2D").get_collider().get_parent().get_parent().get_node("Right").get_child(get_node("RayCast2D").get_collider().get_index()).collision_layer = 1
			get_node("RayCast2D").get_collider().get_parent().get_parent().get_node("Left").get_child(get_node("RayCast2D").get_collider().get_index()).collision_mask = 1
			get_node("RayCast2D").get_collider().get_parent().get_parent().get_node("Right").get_child(get_node("RayCast2D").get_collider().get_index()).collision_mask = 1
			get_node("RayCast2D").get_collider().get_parent().get_parent().get_node("Left").get_child(get_node("RayCast2D").get_collider().get_index()).modulate.a = 1.0
			get_node("RayCast2D").get_collider().get_parent().get_parent().get_node("Right").get_child(get_node("RayCast2D").get_collider().get_index()).modulate.a = 1.0
			pair[0] = true
			can_start = true
	
	if Input.is_action_pressed("game_up") and can_start:
		get_node("CharacterLeft").move_and_collide(Vector2(0.0, -MoveSpeed * delta))
		get_node("CharacterRight").move_and_collide(Vector2(0.0, -MoveSpeed * delta))
	if Input.is_action_pressed("game_down") and can_start:
		get_node("CharacterLeft").move_and_collide(Vector2(0.0, MoveSpeed * delta))
		get_node("CharacterRight").move_and_collide(Vector2(0.0, MoveSpeed * delta))
	if Input.is_action_pressed("game_left") and can_start:
		get_node("CharacterLeft").move_and_collide(Vector2(-MoveSpeed * delta, 0.0))
		get_node("CharacterRight").move_and_collide(Vector2(MoveSpeed * delta, 0.0))
	if Input.is_action_pressed("game_right") and can_start:
		get_node("CharacterLeft").move_and_collide(Vector2(MoveSpeed * delta, 0.0))
		get_node("CharacterRight").move_and_collide(Vector2(-MoveSpeed * delta, 0.0))
	
	get_node("CharacterLeft").move_and_slide()
	get_node("CharacterRight").move_and_slide()
	
	if get_node("CharacterLeft").get_last_slide_collision() != null:
		#print(get_node("CharacterLeft").get_last_slide_collision().get_collider().name)
		if get_node("CharacterLeft").get_last_slide_collision().get_collider().is_in_group("damage"):
			get_node("CharacterLeft").position = Vector2(258, 204)
			get_node("CharacterRight").position = Vector2(1661, 204)
	if get_node("CharacterRight").get_last_slide_collision() != null:
		#print(get_node("CharacterRight").get_last_slide_collision().get_collider().name)
		if get_node("CharacterRight").get_last_slide_collision().get_collider().is_in_group("damage"):
			get_node("CharacterLeft").position = Vector2(258, 204)
			get_node("CharacterRight").position = Vector2(1661, 204)
