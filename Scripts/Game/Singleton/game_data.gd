extends Node

var game_start = 0 # Savoir si la partie a start ou non

var map = [] # Variable qui stock la map sous forme d'un tableau à 2 entrée

var current_player = 0 # POV du joueur actuel

var cell_found = {} # Contient pour chaque joueur, les cellules déjà explorer (donc pas besoin d'explo)

var kingdom = 2 # Nombre de royaumme(joueur/ennemie)
var game_map_size = 20 # Taille de la map de la partie

var kingdom_placed = [] # Variable lors du placement aléatoire des royaumme dans la grille

var player_name = ["Slynous", "Buriquzz"] # contient les noms des joueurs
var player_location = {} # contient le nom et les coordonées des royaumme

func time(delta):
	pass

func setup_player_cell_found():
	for i in player_name:
		cell_found[i] = []
	#cell_found["Slynous"].append("test")
	#print("cell_found : ", cell_found)
