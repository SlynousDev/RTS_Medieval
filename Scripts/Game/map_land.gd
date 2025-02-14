extends Node3D

signal pending_cell # relié à la fonction _on_pending_cell de game_map.gd

@onready var scene_map = $GridMap
@onready var cam = $Camera3D

@export var mesh_lib: MeshLibrary
var new_transform = Transform3D()

var occuped_tile = []
var tile_list = []
var max_structure = 0
var nb_structure = 0


# Func qui permet d'alligner les item de la lib
func set_mesh_lib():
	mesh_lib = scene_map.get_mesh_library()
	if mesh_lib:
		print("Oui il y a une mesh Lib !!!!")
		print("Voici la liste des items : ", mesh_lib.get_item_list())
		
		# item 0 = Castle
		new_transform.origin = Vector3(0,-0.094,0)
		mesh_lib.set_item_mesh_transform(0, new_transform)
		
		# item 1 = Grass block
		new_transform.origin = Vector3(0,-0.031,0)
		mesh_lib.set_item_mesh_transform(1, new_transform)
		
		# item 2 = Forest
		new_transform.origin = Vector3(0,-0.312,0)
		mesh_lib.set_item_mesh_transform(2, new_transform)
		
		# item 3 = Mountain
		new_transform.origin = Vector3(0,-0.095,0.1)
		mesh_lib.set_item_mesh_transform(3, new_transform)
		
		# item 4 = Fairy tree
		new_transform.origin = Vector3(0,-0.437,0)
		mesh_lib.set_item_mesh_transform(4, new_transform)
		
		# item 5 = Vault
		new_transform.origin = Vector3(0,-0.219,0)
		mesh_lib.set_item_mesh_transform(5, new_transform)
		
		# item 6 = Maze
		new_transform.origin = Vector3(0,-0.5,0.06)
		mesh_lib.set_item_mesh_transform(6, new_transform)
		
		# item 7 = Snwo block
		new_transform.origin = Vector3(0,-0.5,0)
		mesh_lib.set_item_mesh_transform(7, new_transform)
		
		# item 8 = Sand block
		new_transform.origin = Vector3(0,-0.5,0)
		mesh_lib.set_item_mesh_transform(8, new_transform)
		
		# item 9 = Lava herb
		new_transform.origin = Vector3(0,-0.5,0)
		mesh_lib.set_item_mesh_transform(9, new_transform)
		
		# item 10 = Pyramid
		new_transform.origin = Vector3(0,-0.5,0)
		mesh_lib.set_item_mesh_transform(10, new_transform)
		
		# item 11 = Eerie Orb
		new_transform.origin = Vector3(0,0.312,0)
		mesh_lib.set_item_mesh_transform(11, new_transform)
		
		# item 12 = Ice Castle
		new_transform.origin = Vector3(-0.15,-0.5,0)
		mesh_lib.set_item_mesh_transform(12, new_transform)
		
		# item 13 = Igloo
		new_transform.origin = Vector3(0,-0.5,0)
		mesh_lib.set_item_mesh_transform(13, new_transform)
		
	else:
		print("Non il n'y a pas une mesh Lib !!!!")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	set_mesh_lib()
	

	# Permet d'exporter la fonction "_on_map_discover" vers "../Game_map" à traver la variable map_discover
	# La variable map_discover doit être déclarer en tant que signal puis utilisé comme ceci :
	# emit_signal("map_discover", coords: Vector2i, size: int, biome: int, main_tile: int, forest: bool = false, mountain: bool = false)
	var searcher = get_node("../Game_map")
	searcher.map_discover.connect(_on_map_discover)
	
	var searcher_to_cell = get_node("../Game_map")
	searcher_to_cell.to_cell.connect(_on_go_to_the_cell)
	
	var starting = get_node("../Game_map")
	starting.start_game.connect(_on_starting_game)
	
	
	#create_new_scene(size, grass, vault, true, true)

# Func qui permet de générer le sol d'une scène
func set_land(size: int, type: int):
	for i in range(-(size/2),(size/2)+1):
		for j in range(-(size/2),(size/2)+1):
			scene_map.set_cell_item(Vector3i(i,1,j), type, 0)


# Func qui ajoute un bloc "Type" "num_max" de fois sur la zone "size", cette dernière corresponds en général à la taille de la map
func add_Tile(size: int, type: int, num_max: int):
	var max_structure = size*size
	nb_structure += num_max
	if nb_structure > max_structure:
		pass
	else:
		var long = size
		var larg = long
		for i in range(0,num_max):
			while true:
				var x = randi_range(-(long/2)+1,(long/2)-1)
				var y = randi_range(-(larg/2)+1,(larg/2)-1)
				if Vector3i(x,1,y) in occuped_tile:
					pass
				else:
					var ori = [0, 10, 16, 22] # Orientation de la cellule
					var final_ori = ori[randi() % ori.size()]
					#scene_map.set_cell_item(Vector3i(x,2,y), type, final_ori)
					tile_list.append(EnvData.add_new_point_of_interest(Vector3i(x,2,y), type))
					occuped_tile.append(Vector3i(x,1,y))
					break

# Func qui permet de gérer les entrées clavier/souris/gamepad
func _input(event):

	if Input.is_action_just_pressed("buy_building"):
		emit_signal("pending_cell")
		#print("Data : ", EnvData.get_scene_data(EnvData.select_cell))
		#print("Ce qu'il y a dans : full_map_list ", EnvData.full_map_list)
		scene_map.clear()
	
	if Input.is_action_just_pressed("expedition"):
		scene_map.clear()
		emit_signal("pending_cell")
		recreate_scene(EnvData.select_cell)

# Func qui permet de créer une nouvelle scène
func create_new_scene(size: int, biome: int, main_tile: int, forest_here: bool = false, mountain_here: bool = false):
	add_Tile(size, main_tile, 1)
	
	if main_tile == EnvData.castle:
		add_Tile(size, EnvData.forest, 2)
	else:
		if forest_here == true:
			add_Tile(size, EnvData.forest, randi_range(1, 2))
		else:
			print("pas de forêt !!!")
	
	if main_tile == EnvData.castle:
		add_Tile(size, EnvData.mountain, 1)
	else:
		if mountain_here == true:
			add_Tile(size, EnvData.mountain, randi_range(1, 2))
		else:
			print("pas de montagne !!!")
	
	#scene_map.clear()
	

# Func qui permet de refaire une scène déjà faite avant
func recreate_scene(coords: Vector2i):
	#print("===================================")
	var data = EnvData.get_scene_data(coords)
	#print("Voici ce que j'ai : ", data)
	#print("Voici full_map_list : ", EnvData.full_map_list)
	#scene_map.clear()
	for i in range(0,len(EnvData.full_map_list)):
		if EnvData.full_map_list[i]["coords"] == coords:
			
			#print("Oui ", EnvData.full_map_list[i]["coords"], " est bien présent")
			var re_size = data["size"]
			var re_biome = data["biome"]
			#print("re_biome : ", re_biome)
			var re_poi_list = data["poi_list"]
			#print("Voici les poi : ", re_poi_list)
			
			
			# Selection des biomes
			if re_biome == EnvData.grass:
				set_land(re_size, EnvData.grass)
			if re_biome == EnvData.snow:
				set_land(re_size, EnvData.snow)
			if re_biome == EnvData.desert:
				set_land(re_size, EnvData.desert)
			if re_biome == EnvData.lava:
				set_land(re_size, EnvData.lava)
			
			# Recherche des poi et les places sur la scène
			for k in range(0,len(re_poi_list)):
				#print("Coords du poi : ", re_poi_list[k]["coords"])
				#print("Item_name du poi : ", re_poi_list[k]["item_name"])
				scene_map.set_cell_item(re_poi_list[k]["coords"], re_poi_list[k]["item_name"])
			break
	
	if $"../Game_map/Full_Map".visible:
		$"../Game_map/Full_Map".hide()
	
	cam.on_recreate_map()
	#print("c'est refait !")
	


# Func qui permet de créer les scène de départ lors de la création de la partie
func start_scene():
	pass

# Func qui permet de créer une nouvelle scène lors de la fin d'une expédition
func _on_map_discover(coords: Vector2i, size: int, biome: int, main_tile: int, forest: bool = false, mountain: bool = false):
	#print("voici size : ", size, " | voici biome : ", biome, " | voici main_tile : ", main_tile, " | voici forest : ", forest, " | voici mountain : ", mountain)
	create_new_scene(size, biome, main_tile, forest, mountain)
	EnvData.add_new_scene_map(coords, size, biome, tile_list)
	tile_list = []

# Func qui fait des choses en début de partie
func _on_starting_game():
	var coords_player = GameData.player_location[GameData.player_name[GameData.current_player]]
	
	# Il faut changer la valeur ici pour changer de pov
	if GameData.current_player == 0:
		print("Mes infos : ", coords_player, " Mon pseudo : ", GameData.player_name[GameData.current_player])
		recreate_scene(coords_player)

# Func qui permet d'afficher la scène sélectionnée
func _on_go_to_the_cell(coords: Vector2i):
	scene_map.clear()
	emit_signal("pending_cell")
	recreate_scene(EnvData.select_cell)
