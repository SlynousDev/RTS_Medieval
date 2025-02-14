extends Node

# Variable de Biome
var grass = 1
var snow = 7
var desert = 8
var lava = 9

var biome_list = [grass, snow, desert, lava]


# Variable de poi
var castle = 0
var forest = 2
var mountain = 3

# Biome Grass
var fairy_tree = 4
var vault = 5
var maze = 6

var grass_poi = [fairy_tree, vault, maze]

# Biome Snow
var ice_castle = 12
var igloo = 13

var snow_poi = [ice_castle, igloo]

# Biome Desert
var pyramid = 10

var desert_poi = [pyramid]

# Biome Lava
var eerie_orb = 11

var lava_poi = [eerie_orb]


var full_map_scene = {} # Contiens les informations d'une chaque scène découverte
var full_map_list = [] # Contiens toutes les scènes découvertes avec leur informations
var select_cell = Vector2i()

# Func qui ajoute à la liste entière une nouvelle scène
func add_new_scene_map(coords: Vector2i, size: int, biome: int, poi_list: Array):
	full_map_scene = {
		"coords": coords,
		"size": size,
		"biome": biome,
		"poi_list": poi_list
	}
	full_map_list.append(full_map_scene)


# Func qui retourne si les coords en entrée son présente dans la full_map_list, donc si la scène éxiste ou non
func check_if_existed(coords_here: Vector2i) -> bool:
	var is_here: bool
	for la in range(0,len(full_map_list)):
		if full_map_list[la]["coords"] == coords_here:
			is_here = true
		else:
			is_here = false
	return is_here

# Func qui retourne un dico des informations d'une scène de la map
func get_scene_data(coords: Vector2i) -> Dictionary:
	var data = {}
	for scene in full_map_list:
		if scene["coords"] == coords:
			data = {
				"coords": scene["coords"],
				"size": scene["size"],
				"biome": scene["biome"],
				"poi_list": scene["poi_list"]
			}
	return data
	
# Func qui retourne un dico d'un POI pour la création d'une map
func add_new_point_of_interest(coords: Vector3i, item_name: int) -> Dictionary:
	var poi = {
		"coords": coords,
		"item_name": item_name,
	}
	return poi

# Func qui permet de choisir un biome aléatoire
func choose_random_biome() -> int:
	var biome = biome_list[randi() % biome_list.size()]
	return biome

# Func qui permet de choisir un POI aléatoire en fonction du biome donné
func choose_random_biome_POI(biome: int) -> int:
	var poi
	
	if biome == 1: # Biome grass
		poi = grass_poi[randi() % grass_poi.size()]
	if biome == 7: # Biome snow
		poi = snow_poi[randi() % snow_poi.size()]
	if biome == 8: # Biome desert
		poi = desert_poi[randi() % desert_poi.size()]
	if biome == 9: # Biome lava
		poi = lava_poi[randi() % lava_poi.size()]
		
	#print("J'ai ce poi : ", poi)
	
	return poi
