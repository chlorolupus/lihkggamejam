extends Node2D


var CardDefaultPos : Vector2 = Vector2(600.0, 600.0)

var CitiesStats = [[5.0, 5.0, 5.0, 5.0], [5.0, 5.0, 5.0, 5.0]]
var CardEffect = [0, 0.0, 0, 0.0]

var IsGrabbing : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_node("RayCast2D").position = get_global_mouse_position()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		#print(get_node("RayCast2D").position)
		#print(get_node("Card").position)
		if get_node("RayCast2D").get_collider() == get_node("Card"):
			IsGrabbing = true
		if IsGrabbing:
			get_node("Card/Sprite").modulate = Color.RED
			get_node("Card").position = get_global_mouse_position()
		#else:
			#get_node("Card/Sprite").modulate = Color.WHITE
	else:
		IsGrabbing = false
		if get_node("RayCast2D").get_collider() == get_node("CityA"):
			apply_card_effect(0, CardEffect[0], CardEffect[1], CardEffect[2], CardEffect[3])
			
		get_node("Card").position = CardDefaultPos
	
func apply_card_effect(City : int, Stat1 : int, Effect1 : float, Stat2 : int, Effect2 : float):
	pass
	
	
