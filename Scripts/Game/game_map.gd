extends Node

signal expe_finish # relié à la fonction _on_exp_finish de game.gd
signal map_discover # relié à la fonction _on_map_discover de map_land.gd
signal to_cell # relié à la fonction _on_go_to_the_cell de map_land.gd
signal start_game # relié à la fonction _on_starting_game de map_land.gd

@onready var game_script = get_node("res://Scripts/Game/game.gd")

@onready var square =$Full_Map/Map/Square
@onready var symbol =$Full_Map/Map/Symbol

@onready var timer_exp = $Timer_exp
@onready var expedition_remaning_label =$Explo_time_remaining
@onready var expedition_container = $Full_Map/Expedition  # Un VBoxContainer pour afficher les expéditions



var old_cell_name = "Unknow_Tile"
var old_cell_coords = Vector2i(-1000,-1000)

var tiles ={
	"Unknow_Tile" : {"value" : Vector2i(-2,-2)},
	"blank_tile" : {"value" : Vector2i(0,0)},
	"enemy_tile" : {"value" : Vector2i(1,0)},
	"clear_tile" : {"value" : Vector2i(2,0)},
	"player_tile" : {"value" : Vector2i(3,0)},
	"pending_tile" : {"value" : Vector2i(4,0)},
	"running_tile" : {"value" : Vector2i(5,0)},
}

# Variables pour les exp
var nb_max_exp = 3 # Nombre max d'expéditions
var nb_exp = 0 # Nombre d'expéditions actuelle
var expeditions = []
var expeditions_running = [] #
var exp_time = 3 # Secondes pour une expédition



# Called when the node enters the scene tree for the first time.
func _ready():
	
	GameData.setup_player_cell_found()
	
	var searcher = get_node("../Map_Land")
	searcher.pending_cell.connect(_on_pending_cell)

	# Définir les paramètres
	var x = GameData.game_map_size+1  # Taille de la grille
	var bords = 3 # distance entre chaque royaumme et un bords de la map
	var wide = 2 # épaisseur du tore dans lequel on place les royaumes
	
	var dist_min = 7 # Distance minimum entre chaque royaumme
	var placed_positions = []
	var placed = 0
	
	# Créer une grille x * x remplie de "."
	var grille = []
	for i in range(x):
		grille.append([])
		for j in range(x):
			grille[i].append(".")
	
	# la map est fini donc on l ajoute au singleton
	GameData.map = grille
	

	while placed < GameData.kingdom:
		var i = randi_range(0 + bords, x - (bords+1))
		var j = randi_range(0 + bords, x - (bords+1))
		var new_pos = Vector2i(j, i)
		
		#print("voici x : ", j+1, " voici y : ", i+1, " Ce qui veut dire sur la map x : ", (-(GameData.game_map_size / 2))+j, " y : ", (-(GameData.game_map_size / 2))+i)
		
		if is_in_tore(i, j, x, bords, wide) and GameData.map[i][j] == ".":
			var valid = true
			for pos in placed_positions:
				if UseFunc.manhattan_distance(pos, new_pos) < dist_min:
					valid = false
					break
			if valid:
				GameData.map[i][j] = "P"
				placed_positions.append(new_pos)
				GameData.kingdom_placed.append(Vector2i((-(GameData.game_map_size / 2) + j), (-(GameData.game_map_size / 2) + i)))
				placed += 1
	#print("GameData.kingdom_placed : ", GameData.kingdom_placed)
	
	kingdom_selector()
	
	# Afficher la grille dans la console
	for ligne in grille:
		#print(ligne)
		pass
		
	init_full_map(GameData.map)

# Func qui permet d'assigner un joueur/enemie à un royaumme
func kingdom_selector():
	var range = 6
	for i in range(len(GameData.kingdom_placed)):
		GameData.player_location[GameData.player_name[i]] = GameData.kingdom_placed[i]
		GameData.cell_found[GameData.player_name[i]].append(GameData.kingdom_placed[i])
		emit_signal("map_discover", GameData.kingdom_placed[i], range, EnvData.grass, EnvData.castle, UseFunc.rnd_percent_bool(1.0), UseFunc.rnd_percent_bool(1.0))
		#print(GameData.kingdom_placed[i])
	print("GameData.cell_found : ", GameData.cell_found)
	#print("cell_found de Slynous : ", GameData.cell_found[GameData.player_name[GameData.current_player]])
	#print(EnvData.full_map_list)
	emit_signal("start_game")

# Func qui créé un tore sur la grille où l'on peut placer les royaumme au début
func is_in_tore(i: int, j: int, size: int, bords: int, wide: int) -> bool:
	var outer_limit = size - bords -1
	var inner_limit = bords + wide
	
	var in_outer_square = (i >= bords and i <= outer_limit and j >= bords and j <= outer_limit)
	var in_inner_square = (i >= inner_limit and i <= size - inner_limit - 1 and j >= inner_limit and j <= size - inner_limit - 1)
	
	return in_outer_square and not in_inner_square

# Func pour initialiser la full map
func init_full_map(grille):

	var min_map = -(len(grille)/2)
	var max_map = len(grille)/2
	
	#print("On va de : ", min_map, " jusqu'à : ", max_map)
	for i in range(min_map, max_map+1):
		for j in range(-(len(grille[i])/2), (len(grille[i])/2)+1):
			#print("coords de la map : ", i, " ", j)
			square.set_cell(Vector2i(i,j), 0, tiles.get("blank_tile").get("value"))
	
	for king_to_place in range(len(GameData.kingdom_placed)):
		#print("à placer : ", GameData.kingdom_placed[king_to_place])
		square.set_cell(GameData.kingdom_placed[king_to_place], 0, tiles.get("player_tile").get("value"))
	GameData.kingdom_placed.clear()

# Func qui retourne le nom de la tuile demandé avec en entrée ses coordonées
func select_tile(target_value: Vector2i) -> String:
	for tile in tiles.keys():
		if tiles[tile]["value"] == target_value:
			return tile
	return "Unknow Tile"

# Func qui retourne une liste avec en [0] = le type de la tuile et en [1] = les coordonées de la tuile sélectionnée
func get_pending_tile() -> Array:
	return [old_cell_name, old_cell_coords]

# Func qui permet d'accéder à une cellule via la map
func go_to_cell(coords: Vector2i):
	if coords == Vector2i(-1000,-1000):
		print("Il faut faire une expedition avant !")
	else:
		#print("GameData.player_name[GameData.current_player] : ", GameData.player_name[GameData.current_player])
		print("GameData.cell_found[GameData.player_name[GameData.current_player] : ", GameData.cell_found[GameData.player_name[GameData.current_player]])
		if coords in GameData.cell_found[GameData.player_name[GameData.current_player]]:
			print("On peut y aller : ", coords)
			emit_signal("to_cell", coords)
		else:
			print("Il faut faire une expedition avant !")

func _input(event):
	
	var dragging = false
	var last_mouse_pos = Vector2.ZERO
	
	if Input.is_action_just_pressed("left_click") and $Full_Map.visible:
		
		var tile_name = "" # Nom de la tile sur l'atlas
		
		var mouse_pos = get_viewport().get_mouse_position()  # Position globale du clic
		var local_pos = square.to_local(mouse_pos)  # Convertir en position locale
		var cell_coords = square.local_to_map(local_pos)  # Convertir en coordonnées de cellule
		
		var source_id = square.get_cell_source_id(cell_coords)  # Récupère l'ID du tileset
		var atlas_coords = square.get_cell_atlas_coords(cell_coords)  # Récupère la position dans le tileset

		#tile_name = tiles.get("blank_tile").get("value")
		var cell_name = select_tile(atlas_coords)

		if cell_name != "Unknow Tile":
			#print("Le cell_name : ", cell_name)
			#print("Ancienne Cellule : ", old_cell_name, " aux anciennes coordonnées : ", old_cell_coords)
			if old_cell_name == "running_tile":
				pass
			else:
				square.set_cell(old_cell_coords, 0, tiles.get(old_cell_name).get("value"))
			if cell_name != "pending_tile":
				old_cell_name = cell_name
				old_cell_coords = cell_coords
			square.set_cell(cell_coords, 0, tiles.get("pending_tile").get("value"))
			#print(get_pending_tile())
	
	if Input.is_action_just_pressed("show_hide_map"):
		if $Full_Map.visible:
			$Full_Map.hide()
		else:
			$Full_Map.show()
			square.position = Vector2(1,1)
			square.scale = Vector2(1,1)


# Func qui lance un timer pour une expédition
func start_expedition(expedition_time: float):
	# Ajoute une nouvelle expédition avec un timer de décompte
	var new_expedition = {
		"time_left": expedition_time
	}
	expeditions.append(new_expedition)
	update_ui()

func update_ui():
	if expeditions.is_empty():
		expedition_remaning_label.text = "Aucune expédition en cours."
	else:
		expedition_remaning_label.text = "Expéditions en cours: " + str(expeditions.size()) + "\n"
		
		for expedition in expeditions:
			expedition_remaning_label.text += "- " + str(round(expedition["time_left"])) + "s restantes\n"




func _process(delta):
	if expeditions.is_empty():
		return  # Rien à faire s'il n'y a pas d'expéditions
	
	# Mettre à jour le temps restant pour chaque expédition
	for i in range(expeditions.size() -1, -1, -1):
		expeditions[i]["time_left"] -= delta
		
		if expeditions[i]["time_left"] <= 0:
			expeditions.remove_at(i)  # Supprime l'expédition terminée
			#print("coord fini : ", expeditions_running[i], " sur : ", expeditions_running)
			
			square.set_cell(expeditions_running[i], 0, tiles.get("clear_tile").get("value"))
			GameData.cell_found[GameData.player_name[GameData.current_player]].append(expeditions_running[i])
			
			if EnvData.check_if_existed(expeditions_running[i]) == false:
				print("L'expedition à ", expeditions_running[i], " est terminée !!")
				var choosen_biome = EnvData.choose_random_biome()
				emit_signal("map_discover", expeditions_running[i], randi_range(5,9), choosen_biome, EnvData.choose_random_biome_POI(choosen_biome), UseFunc.rnd_percent_bool(0.8), UseFunc.rnd_percent_bool(0.7))
				print("Map crée")
			
			
			expeditions_running.remove_at(0)
			nb_exp -= 1
			
			#emit_signal("expe_finish")
			
				
	update_ui()  # Mise à jour dynamique

func _on_pending_cell():
	var cell = get_pending_tile()[1]
	#print("Ah oui c'est cette cellule : ", cell)
	EnvData.select_cell = cell


func _on_explo_but_pressed() -> void:
	#print("nb_exp : ", nb_exp, " nb_max_exp : ", nb_max_exp)
	if get_pending_tile()[0] == "blank_tile" and get_pending_tile()[0] != "Unknow_Tile" and nb_exp < nb_max_exp:
		old_cell_name = "running_tile"
		old_cell_coords = get_pending_tile()[1]
		expeditions_running.append(old_cell_coords)
		square.set_cell(get_pending_tile()[1], 0, tiles.get("running_tile").get("value"))
		nb_exp += 1
		start_expedition(exp_time)


func _on_go_to_the_cell_pressed() -> void:
	var cell = get_pending_tile()
	#print("cell actuelle : ", cell)
	#print("Cette cellule : ", cell[1])
	go_to_cell(cell[1])
