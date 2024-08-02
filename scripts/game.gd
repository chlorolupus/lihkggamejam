extends Node2D

var MoveSpeed = 450.0

var can_start : bool = false
var pair : Array[bool] = []
var mirror : Array[bool] = []

var deck : Array = [["pair", 0], ["pair", 0], ["pair", 0], ["pair", 1], ["pair", 2], ["pair", 3], ["pair", 3], ["pair", 3], ["pair", 4], ["mirror", 0], ["mirror", 1], ["mirror", 2], ["mirror", 3], ["mirror", 3]]
var extra_deck : Array = [["boss", 0], ["boss", 1], ["boss", 2]]

var score : int = 0

var deck_index : int = 0
var is_next_level : bool = true

var dirmov_vu : float = 100.0
var dirmov_hr : float = 100.0
var dirmov_rrx : float = 100.0
var dirmov_rry : float = 0.0
var dirmov_rlx : float = -100.0
var dirmov_rly : float = 0.0
var modu_a : float = -1.0
var can_appear : bool = false

const boss_level = 7

var life : int = 3

var new_poly : Polygon2D
var once : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	for group in deck:
		if group[0] == "pair":
			pair.push_back(false)
		if group[0] == "mirror":
			mirror.push_back(false)
	for Saw in get_tree().get_nodes_in_group("vert_down"):
		Saw.set_meta("original_place", Saw.position)
	for Saw in get_tree().get_nodes_in_group("vert_up"):
		Saw.set_meta("original_place", Saw.position)
	for Saw in get_tree().get_nodes_in_group("loop_hori_right"):
		Saw.set_meta("original_place", Saw.position)
	for Saw in get_tree().get_nodes_in_group("loop_hori_left"):
		Saw.set_meta("original_place", Saw.position)
	for Saw in get_tree().get_nodes_in_group("loop_vert_up"):
		Saw.set_meta("original_place", Saw.position)
	randomize()
	deck.shuffle()
	extra_deck.shuffle()
	#new_poly = Polygon2D.new()
	#new_poly.polygon = [Vector2(-1000, -1000), Vector2(-1000, 1000), Vector2(1000, 1000), Vector2(1000, -1000)]
	#new_poly.color = Color.RED
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if once:
		once = false
		#get_node("Background").add_child(new_poly)
		#new_poly.set_owner(get_tree().root)
		var inde = 3
		for node in get_tree().get_nodes_in_group("spin"):
			node.light_mask = 0
			node.z_index = inde
			node.get_child(0).z_index = 1
			inde += 10
		for node in get_tree().get_nodes_in_group("walls"):
			node.get_node("Polygon2D").light_mask = 0
			node.get_node("Polygon2D").z_index = inde
			inde += 10
					#for node in get_tree().get_nodes_in_group("walls"):
			#node.get_node("Polygon2D").polygon.push_back(Vector2(0.0, 0.0))
			#node.get_node("Polygon2D").polygon.pop_back()
			#node.remove_child(new_node)
			#new_node.set_owner(null)
			#node.add_child(new_node)
			#new_node.set_owner(node)
		#for node in get_tree().get_nodes_in_group("spin"):
			#pass
		#print(new_poly.get_parent())
		#print(new_poly.get_index())
	if life > 0 and score < 25:
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
				
		for Saw in get_tree().get_nodes_in_group("loop_vert_up"):
			Saw.move_and_collide(Vector2(0.0, -dirmov_vu * delta))
			if Saw.position.y - Saw.get_meta("original_place").y < -600.0:
				dirmov_vu *= -1.0
			elif Saw.position.y >= Saw.get_meta("original_place").y + 5.0:
				dirmov_vu *= -1.0
				
		for Saw in get_tree().get_nodes_in_group("loop_hori_right"):
			Saw.move_and_collide(Vector2(dirmov_hr * delta, 0.0))
			if Saw.position.x - Saw.get_meta("original_place").x > 700.0:
				dirmov_hr *= -1.0
			elif Saw.position.x <= Saw.get_meta("original_place").x - 5.0:
				dirmov_hr *= -1.0
		for Saw in get_tree().get_nodes_in_group("loop_hori_left"):
			Saw.move_and_collide(Vector2(-dirmov_hr * delta, 0.0))
			if Saw.position.x - Saw.get_meta("original_place").x < -700.0:
				dirmov_hr *= -1.0
			elif Saw.position.x >= Saw.get_meta("original_place").x + 5.0:
				dirmov_hr *= -1.0
				
		for Saw in get_tree().get_nodes_in_group("random_left"):
			Saw.move_and_collide(Vector2(dirmov_rlx * delta, dirmov_rly * delta))
			if Saw.global_position.x > 1920:
				dirmov_rlx = -100.0
				dirmov_rly = 50.0 * float(randi() % 2 - 1)
			elif Saw.global_position.y > 1080:
				dirmov_rly = -100.0
				dirmov_rlx = 50.0 * float(randi() % 2 - 1)
			if Saw.global_position.x < 0:
				dirmov_rlx = 100.0
				dirmov_rly = 50.0 * float(randi() % 2 - 1)
			elif Saw.global_position.y < 0:
				dirmov_rly = 100.0
				dirmov_rlx = 50.0 * float(randi() % 2 - 1)
				
		for Saw in get_tree().get_nodes_in_group("random_right"):
			Saw.move_and_collide(Vector2(dirmov_rrx * delta, dirmov_rry * delta))
			if Saw.global_position.x > 1920:
				dirmov_rrx = -100.0
				dirmov_rry = 50.0 * float(randi() % 2 - 1)
			elif Saw.global_position.y > 1080:
				dirmov_rry = -100.0
				dirmov_rrx = 50.0 * float(randi() % 2 - 1)
			if Saw.global_position.x < 0:
				dirmov_rrx = 100.0
				dirmov_rry = 50.0 * float(randi() % 2 - 1)
			elif Saw.global_position.y < 0:
				dirmov_rry = 100.0
				dirmov_rrx = 50.0 * float(randi() % 2 - 1)
			
		for Saw in get_tree().get_nodes_in_group("appear"):
			if Saw.modulate.a < 0.2 and Saw.collision_layer == 16:
				modu_a = 1.0
				Saw.modulate.a += modu_a * 0.25 * delta
			if Saw.collision_layer == 16 or Saw.collision_layer == 1:
				Saw.modulate.a += modu_a * 0.1 * delta
			if Saw.modulate.a >= 0.8 and Saw.collision_layer == 16 and modu_a > 0.0:
				Saw.collision_layer = 1
			if Saw.modulate.a >= 0.95 and Saw.collision_layer == 1:
				Saw.collision_layer = 16
				modu_a = -1.0
			#print(Saw.collision_layer)
				
			
			#if Saw.modulate.a > 80.0:
				#Saw.collision_layer = 1
			#else:
				#Saw.collision_layer = 2
			
		for Saw1 in get_tree().get_nodes_in_group("damage"):
			if Saw1.collision_layer > 1 and Saw1.collision_layer != 16:
				Saw1.modulate.a = 0.0
		
		
		if is_next_level:
			get_node("CharacterLeft").collision_layer = 32
			get_node("CharacterRight").collision_layer = 32
			if deck_index != boss_level and deck[deck_index][0] == "pair":
				#if not pair[deck[deck_index][1]]:
				for Saw1 in get_tree().get_nodes_in_group(deck[deck_index][0] + str(deck[deck_index][1])):
					if Saw1.collision_layer > 1:
						Saw1.modulate.a = 0.5
			if deck_index != boss_level and deck[deck_index][0] == "mirror":
				#if not mirror[deck[deck_index][1]]:
				for Saw1 in get_tree().get_nodes_in_group(deck[deck_index][0] + str(deck[deck_index][1])):
					if Saw1.collision_layer > 1:
						Saw1.modulate.a = 0.5
			if deck_index == boss_level and extra_deck[0][0] == "boss":
				#if not pair[deck[deck_index][1]]:
				for Saw1 in get_tree().get_nodes_in_group(extra_deck[0][0] + str(extra_deck[0][1])):
					if Saw1.collision_layer > 1:
						Saw1.modulate.a = 0.5
			
			for node in get_tree().get_nodes_in_group("damage"):
				if node.collision_layer == 4:
					node.collision_layer = 64
			for node in get_tree().get_nodes_in_group(deck[deck_index][0] + str(deck[deck_index][1])):
				if node.collision_layer == 64:
					node.collision_layer = 4
			get_node("RayCast2D").position = get_global_mouse_position()
			if deck_index != boss_level and get_node("RayCast2D").get_collider() != null and get_node("RayCast2D").get_collider().has_node("CollisionPolygon2D") and get_node("RayCast2D").get_collider().collision_layer == 4 and get_node("RayCast2D").get_collider().is_in_group(deck[deck_index][0] + str(deck[deck_index][1])):
				#get_node("RayCast2D").get_collider().modulate.a = 0.75
				get_node("RayCast2D").get_collider().get_parent().get_parent().get_node("Left").get_child(get_node("RayCast2D").get_collider().get_index()).modulate.a = 0.75
				get_node("RayCast2D").get_collider().get_parent().get_parent().get_node("Right").get_child(get_node("RayCast2D").get_collider().get_index()).modulate.a = 0.75
			elif deck_index == boss_level and get_node("RayCast2D").get_collider() != null and get_node("RayCast2D").get_collider().has_node("CollisionPolygon2D") and get_node("RayCast2D").get_collider().collision_layer == 4 and get_node("RayCast2D").get_collider().is_in_group(extra_deck[0][0] + str(extra_deck[0][1])):
				#get_node("RayCast2D").get_collider().modulate.a = 0.75
				get_node("RayCast2D").get_collider().modulate.a = 0.75
				get_node("RayCast2D").get_collider().modulate.a = 0.75
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				if deck_index != boss_level and get_node("RayCast2D").get_collider() != null and get_node("RayCast2D").get_collider().has_node("CollisionPolygon2D") and get_node("RayCast2D").get_collider().is_in_group(deck[deck_index][0] + str(deck[deck_index][1])):
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
					#if get_node("RayCast2D").get_collider().is_in_group("appear"):
					can_appear = true
					for node in get_tree().get_nodes_in_group("appear"):
						if node.collision_layer == 1 or node.collision_layer == 16:
							node.modulate.a = 0.99
					#mirror[0] = true
					can_start = true
					is_next_level = false
					
					if deck_index != boss_level:
						score += 2
					else:
						score += 1
					
					get_node("CharacterLeft").collision_layer = 32
					get_node("CharacterRight").collision_layer = 32
				elif deck_index == boss_level and get_node("RayCast2D").get_collider() != null and get_node("RayCast2D").get_collider().has_node("CollisionPolygon2D") and get_node("RayCast2D").get_collider().is_in_group(extra_deck[0][0] + str(extra_deck[0][1])):
					#get_node("RayCast2D").get_collider().collision_layer = 1
					#get_node("RayCast2D").get_collider().collision_mask = 1
					#get_node("RayCast2D").get_collider().modulate.a = 1.0
					get_node("RayCast2D").get_collider().collision_layer = 1
					get_node("RayCast2D").get_collider().modulate.a = 1.0
					if get_node("RayCast2D").get_collider().is_in_group("appear"):
						can_appear = true
						for node in get_tree().get_nodes_in_group("appear"):
							node.modulate.a = 0.99
					#mirror[0] = true
					can_start = true
					is_next_level = false
					
					get_node("CharacterLeft").collision_layer = 1
					get_node("CharacterRight").collision_layer = 1
		
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
		
		if get_node("CharacterLeft").get_last_slide_collision() != null and can_start:
			#print(get_node("CharacterLeft").get_last_slide_collision().get_collider().name)
			if get_node("CharacterLeft").get_last_slide_collision().get_collider().is_in_group("damage"):
				get_node("CharacterLeft").position = Vector2(258, 204)
				get_node("CharacterRight").position = Vector2(1661, 204)
				life -= 1
			if get_node("CharacterLeft").get_last_slide_collision().get_collider().is_in_group("flag"):
				get_node("CharacterLeft").position = Vector2(258, 204)
				get_node("CharacterRight").position = Vector2(1661, 204)
				deck_index += 1
				if deck_index < min(12, deck.size()):
					can_start = false
					is_next_level = true
		elif get_node("CharacterRight").get_last_slide_collision() != null and can_start:
			#print(get_node("CharacterRight").get_last_slide_collision().get_collider().name)
			if get_node("CharacterRight").get_last_slide_collision().get_collider().is_in_group("damage"):
				get_node("CharacterLeft").position = Vector2(258, 204)
				get_node("CharacterRight").position = Vector2(1661, 204)
				life -= 1
			if get_node("CharacterRight").get_last_slide_collision().get_collider().is_in_group("flag"):
				get_node("CharacterLeft").position = Vector2(258, 204)
				get_node("CharacterRight").position = Vector2(1661, 204)
				deck_index += 1
				if deck_index < min(12, deck.size()):
					can_start = false
					is_next_level = true
				else:
					pass
		get_node("Polygon2D/Label").text = str(life)
		get_node("Score").text = str("Disc " + str(score))
	elif life == 0:
		get_node("GameOver").visible = true
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			get_tree().reload_current_scene()
	elif score >= 25:
		get_node("Win").visible = true
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			get_tree().reload_current_scene()
