extends Node2D

var MoveSpeed = 450.0

var can_start : bool = false
var pair : Array[bool] = []
var mirror : Array[bool] = []

var deck : Array = [["pair", 0], ["mirror", 0], ["mirror", 1]]

var deck_index : int = 0
var is_next_level : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	for group in get_groups():
		if group.find("pair") != -1:
			pair.push_back(false)
		if group.find("mirror") != -1:
			mirror.push_back(false)
	for Saw in get_tree().get_nodes_in_group("vert_down"):
		Saw.set_meta("original_place", Saw.position)
	for Saw in get_tree().get_nodes_in_group("vert_up"):
		Saw.set_meta("original_place", Saw.position)
	deck.shuffle()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for Saw in get_tree().get_nodes_in_group("spin"):
		Saw.rotation += 20 * delta
	
	for Saw in get_tree().get_nodes_in_group("vert_down"):
		Saw.move_and_collide(Vector2(0.0, 100 * delta))
		if Saw.position.y - Saw.get_meta("original_place").y > 600.0:
			Saw.position = Saw.get_meta("original_place")
	
	for Saw in get_tree().get_nodes_in_group("vert_up"):
		Saw.move_and_collide(Vector2(0.0, -100 * delta))
		if Saw.position.y - Saw.get_meta("original_place").y < -600.0:
			Saw.position = Saw.get_meta("original_place")
	
	for Saw1 in get_tree().get_nodes_in_group("damage"):
		if Saw1.collision_layer > 1:
			Saw1.modulate.a = 0.0
		
	if is_next_level:
		if deck[deck_index][0] == "pair":
			if not pair[deck[deck_index][1]]:
				for Saw1 in get_tree().get_nodes_in_group(deck[deck_index][0] + str(deck[deck_index][1])):
					if Saw1.collision_layer > 1:
						Saw1.modulate.a = 0.5
		if deck[deck_index][0] == "mirror":
			if not mirror[deck[deck_index][1]]:
				for Saw1 in get_tree().get_nodes_in_group(deck[deck_index][0] + str(deck[deck_index][1])):
					if Saw1.collision_layer > 1:
						Saw1.modulate.a = 0.5
		
		get_node("RayCast2D").position = get_global_mouse_position()
		if get_node("RayCast2D").get_collider() != null and get_node("RayCast2D").get_collider().has_node("CollisionPolygon2D") and get_node("RayCast2D").get_collider().collision_layer > 1 and get_node("RayCast2D").get_collider().is_in_group(deck[deck_index][0] + str(deck[deck_index][1])):
			#get_node("RayCast2D").get_collider().modulate.a = 0.75
			get_node("RayCast2D").get_collider().get_parent().get_parent().get_node("Left").get_child(get_node("RayCast2D").get_collider().get_index()).modulate.a = 0.75
			get_node("RayCast2D").get_collider().get_parent().get_parent().get_node("Right").get_child(get_node("RayCast2D").get_collider().get_index()).modulate.a = 0.75
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if get_node("RayCast2D").get_collider() != null and get_node("RayCast2D").get_collider().has_node("CollisionPolygon2D") and get_node("RayCast2D").get_collider().is_in_group(deck[deck_index][0] + str(deck[deck_index][1])):
				#get_node("RayCast2D").get_collider().collision_layer = 1
				#get_node("RayCast2D").get_collider().collision_mask = 1
				#get_node("RayCast2D").get_collider().modulate.a = 1.0
				get_node("RayCast2D").get_collider().get_parent().get_parent().get_node("Left").get_child(get_node("RayCast2D").get_collider().get_index()).collision_layer = 1
				get_node("RayCast2D").get_collider().get_parent().get_parent().get_node("Right").get_child(get_node("RayCast2D").get_collider().get_index()).collision_layer = 1
				#get_node("RayCast2D").get_collider().get_parent().get_parent().get_node("Left").get_child(get_node("RayCast2D").get_collider().get_index()).collision_mask = 1
				#get_node("RayCast2D").get_collider().get_parent().get_parent().get_node("Right").get_child(get_node("RayCast2D").get_collider().get_index()).collision_mask = 1
				get_node("RayCast2D").get_collider().get_parent().get_parent().get_node("Left").get_child(get_node("RayCast2D").get_collider().get_index()).modulate.a = 1.0
				get_node("RayCast2D").get_collider().get_parent().get_parent().get_node("Right").get_child(get_node("RayCast2D").get_collider().get_index()).modulate.a = 1.0
				
				if deck[deck_index][0] == "pair":
					pair[deck[deck_index][1]] = true
				if deck[deck_index][0] == "mirror":
					mirror[deck[deck_index][1]] = true
				#mirror[0] = true
				can_start = true
				is_next_level = false
	
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
		if get_node("CharacterLeft").get_last_slide_collision().get_collider().is_in_group("flag"):
			get_node("CharacterLeft").position = Vector2(258, 204)
			get_node("CharacterRight").position = Vector2(1661, 204)
			deck_index += 1
			if deck_index < deck.size():
				can_start = false
				is_next_level = true
			else:
				pass
	elif get_node("CharacterRight").get_last_slide_collision() != null:
		#print(get_node("CharacterRight").get_last_slide_collision().get_collider().name)
		if get_node("CharacterRight").get_last_slide_collision().get_collider().is_in_group("damage"):
			get_node("CharacterLeft").position = Vector2(258, 204)
			get_node("CharacterRight").position = Vector2(1661, 204)
		if get_node("CharacterRight").get_last_slide_collision().get_collider().is_in_group("flag"):
			get_node("CharacterLeft").position = Vector2(258, 204)
			get_node("CharacterRight").position = Vector2(1661, 204)
			deck_index += 1
			if deck_index < deck.size():
				can_start = false
				is_next_level = true
			else:
				pass
