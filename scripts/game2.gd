extends Node3D


enum Building {Empty, Food, Bonfire, Population, Strength}

var IsDragging : bool = false
var IsLeftClicked : bool = false
var ChosenSlot : int = 0

var Deck : Array[Building] = [Building.Food, Building.Bonfire, Building.Population, Building.Strength, \
							Building.Food, Building.Bonfire, Building.Population, Building.Strength]
#var Deck : Array[Building] = [Building.Food, Building.Food, Building.Food, Building.Food, \
							#Building.Food, Building.Food, Building.Food, Building.Food]
var DeckIndex : int = 0

var VillageBuilding : Array = [[[Building.Empty, 0], [Building.Empty, 0], \
[Building.Empty, 0], [Building.Empty, 0], [Building.Empty, 0], [Building.Empty, 0], \
[Building.Empty, 0], [Building.Empty, 0], [Building.Empty, 0], [Building.Empty, 0], \
[Building.Empty, 0], [Building.Empty, 0], [Building.Empty, 0], [Building.Empty, 0], \
[Building.Empty, 0], [Building.Empty, 0], [Building.Empty, 0], [Building.Empty, 0], \
[Building.Empty, 0], ], [[Building.Empty, 0], [Building.Empty, 0], \
[Building.Empty, 0], [Building.Empty, 0], [Building.Empty, 0], [Building.Empty, 0], \
[Building.Empty, 0], [Building.Empty, 0], [Building.Empty, 0], [Building.Empty, 0], \
[Building.Empty, 0], [Building.Empty, 0], [Building.Empty, 0], [Building.Empty, 0], \
[Building.Empty, 0], [Building.Empty, 0], [Building.Empty, 0], [Building.Empty, 0], \
[Building.Empty, 0],]]

# Called when the node enters the scene tree for the first time.
func _ready():
	Deck.shuffle()
	DeckIndex = 0
	if Deck[DeckIndex] == Building.Food:
		get_node("BushesCard").visible = true
	if Deck[DeckIndex] == Building.Bonfire:
		get_node("BonfireCard").visible = true
	if Deck[DeckIndex] == Building.Population:
		get_node("HutCard").visible = true
	if Deck[DeckIndex] == Building.Strength:
		get_node("ToolHutCard").visible = true
		
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
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not IsLeftClicked:
		if get_node("RayCast3D").get_collider() is StaticBody3D and get_node("RayCast3D").get_collider().get_parent() is MeshInstance3D:
			IsLeftClicked = true
			ChosenSlot = get_node("RayCast3D").get_collider().get_parent().get_index()
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and IsLeftClicked:
		#if IsDragging:
			#get_node("Card").modulate = Color(1, 1, 1, 0.5)
		IsLeftClicked = false
		if get_node("RayCast3D").get_collider() is StaticBody3D and get_node("RayCast3D").get_collider().get_parent() is MeshInstance3D and get_node("RayCast3D").get_collider().get_parent().get_index() == ChosenSlot:
			get_node("RayCast3D").get_collider().get_parent().mesh.material.albedo_color = Color.RED
			var Popback = Deck[DeckIndex]
			var ChosenVillage = 0
			if get_node("RayCast3D").get_collider().get_parent().get_parent().name == 'VillageB':
				ChosenVillage = 1
			if VillageBuilding[ChosenVillage][ChosenSlot % 19][0] == Building.Empty:
				DeckIndex += 1
				if DeckIndex >= 8:
					DeckIndex = 0
					Deck.shuffle()
				get_node("BushesCard").visible = false
				get_node("BonfireCard").visible = false
				get_node("HutCard").visible = false
				get_node("ToolHutCard").visible = false
				if Deck[DeckIndex] == Building.Food:
					get_node("BushesCard").visible = true
				if Deck[DeckIndex] == Building.Bonfire:
					get_node("BonfireCard").visible = true
				if Deck[DeckIndex] == Building.Population:
					get_node("HutCard").visible = true
				if Deck[DeckIndex] == Building.Strength:
					get_node("ToolHutCard").visible = true
				if Popback == Building.Population:
					VillageBuilding[ChosenVillage][ChosenSlot][0] = Building.Population
					VillageBuilding[ChosenVillage][ChosenSlot][1] = 1
					get_node("RayCast3D").get_collider().get_parent().get_node("Hut").visible = true
				elif Popback == Building.Bonfire:
					VillageBuilding[ChosenVillage][ChosenSlot][0] = Building.Bonfire
					VillageBuilding[ChosenVillage][ChosenSlot][1] = 1
					get_node("RayCast3D").get_collider().get_parent().get_node("Bonfire").visible = true
				elif Popback == Building.Food:
					VillageBuilding[ChosenVillage][ChosenSlot][0] = Building.Food
					VillageBuilding[ChosenVillage][ChosenSlot][1] = 1
					get_node("RayCast3D").get_collider().get_parent().get_node("Bushes").visible = true
				elif Popback == Building.Strength:
					VillageBuilding[ChosenVillage][ChosenSlot][0] = Building.Strength
					VillageBuilding[ChosenVillage][ChosenSlot][1] = 1
					get_node("RayCast3D").get_collider().get_parent().get_node("ToolHut").visible = true
			elif VillageBuilding[ChosenVillage][ChosenSlot % 19][0] != Building.Empty and VillageBuilding[ChosenVillage][ChosenSlot % 19][0] != Building.Bonfire and Popback == Building.Bonfire:
				DeckIndex += 1
				if DeckIndex >= 8:
					DeckIndex = 0
					Deck.shuffle()
				get_node("BushesCard").visible = false
				get_node("BonfireCard").visible = false
				get_node("HutCard").visible = false
				get_node("ToolHutCard").visible = false
				if Deck[DeckIndex] == Building.Food:
					get_node("BushesCard").visible = true
				if Deck[DeckIndex] == Building.Population:
					get_node("HutCard").visible = true
				if Deck[DeckIndex] == Building.Strength:
					get_node("ToolHutCard").visible = true
				if Deck[DeckIndex] == Building.Bonfire:
					get_node("BonfireCard").visible = true
				VillageBuilding[ChosenVillage][ChosenSlot][0] = Building.Empty
				VillageBuilding[ChosenVillage][ChosenSlot][1] = 0
				get_node("RayCast3D").get_collider().get_parent().get_node("Hut").visible = false
				get_node("RayCast3D").get_collider().get_parent().get_node("Bushes").visible = false
				get_node("RayCast3D").get_collider().get_parent().get_node("ToolHut").visible = false
			#IsDragging = true
	#elif IsDragging and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		#IsDragging = false
		#if get_node("RayCast3D").get_collider() is StaticBody3D and get_node("RayCast3D").get_collider().get_parent() is MeshInstance3D:
			#get_node("RayCast3D").get_collider().get_parent().get_node("Hut").visible = true
			#pass
	#else:
		#IsDragging = false
		#get_node("Card").transform.origin = Vector3(-2.7, -0.83, -2.1)
	pass
