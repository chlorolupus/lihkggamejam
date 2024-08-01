extends Node2D

var MoveSpeed = 450.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for Saw in get_node("SpinningSaws").get_children():
		Saw.rotation += 20 * delta
	
	if Input.is_action_pressed("game_up"):
		get_node("CharacterLeft").move_and_collide(Vector2(0.0, -MoveSpeed * delta))
		get_node("CharacterRight").move_and_collide(Vector2(0.0, -MoveSpeed * delta))
	if Input.is_action_pressed("game_down"):
		get_node("CharacterLeft").move_and_collide(Vector2(0.0, MoveSpeed * delta))
		get_node("CharacterRight").move_and_collide(Vector2(0.0, MoveSpeed * delta))
	if Input.is_action_pressed("game_left"):
		get_node("CharacterLeft").move_and_collide(Vector2(-MoveSpeed * delta, 0.0))
		get_node("CharacterRight").move_and_collide(Vector2(MoveSpeed * delta, 0.0))
	if Input.is_action_pressed("game_right"):
		get_node("CharacterLeft").move_and_collide(Vector2(MoveSpeed * delta, 0.0))
		get_node("CharacterRight").move_and_collide(Vector2(-MoveSpeed * delta, 0.0))
	
	get_node("CharacterLeft").move_and_slide()
	get_node("CharacterRight").move_and_slide()
	
	if get_node("CharacterLeft").get_last_slide_collision() != null:
		print(get_node("CharacterLeft").get_last_slide_collision().get_collider().name)
		if get_node("CharacterLeft").get_last_slide_collision().get_collider().name == "Damage":
			if get_node("CharacterLeft").get_last_slide_collision().get_collider().get_parent().modulate.a > 80.0:
				get_node("CharacterLeft").position = Vector2(258, 204)
				get_node("CharacterRight").position = Vector2(1661, 204)
	if get_node("CharacterRight").get_last_slide_collision() != null:
		print(get_node("CharacterRight").get_last_slide_collision().get_collider().name)
		if get_node("CharacterRight").get_last_slide_collision().get_collider().name == "Damage":
			if get_node("CharacterRight").get_last_slide_collision().get_collider().get_parent().modulate.a > 80.0:
				get_node("CharacterLeft").position = Vector2(258, 204)
				get_node("CharacterRight").position = Vector2(1661, 204)
