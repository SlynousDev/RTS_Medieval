extends Node

# Variables importantes
var timer = 0.1 #change l'affichage des ressources
var last_loot = "Aucune expédition encore." #placeholder pour les exepditions dans le label

# Dico/variables pour les réliques
# Reliques en possésion
var relics = {}



# Dico pour les ressources
var resources = {
	"gold": {"name": "Gold", "amount": 0, "max": 100,"per_second": 1.0, "partial": 0.0},
	"wood": {"name": "Wood", "amount": 0, "max": 500, "per_second": 1.0, "partial": 0.0},
}



# Func pour initialiser le tout
func _ready() -> void:
	
	var searcher = get_node("Game_map")
	searcher.expe_finish.connect(_on_exp_finish)
	
	$Timer.wait_time = timer
	$Timer.timeout.connect(_on_timer_timeout)
	update_ui()


# Func pour la prod de ressources
func _on_timer_timeout() -> void:
	for res in resources.keys():
		if resources[res]["amount"] < resources[res]["max"]:  # Vérifie si on peut encore produire
			var base_prod = resources[res]["per_second"]
			var bonus_multiplier = LootTable.get_relic_bonus(relics, res)
			var total_prod = base_prod * bonus_multiplier * timer
			
			resources[res]["partial"] += total_prod  

			if resources[res]["partial"] >= 1.0:
				var to_add = int(resources[res]["partial"])
				resources[res]["partial"] -= to_add
				resources[res]["amount"] += to_add

				# Empêche de dépasser le max
				if resources[res]["amount"] >= resources[res]["max"]:
					resources[res]["amount"] = resources[res]["max"]
					resources[res]["partial"] = 0.0
				
	print_status()


# Func pour maj les ressources
func print_status() -> void:
	update_ui()
	#print("Or:", resources["gold"]["amount"], "/", resources["gold"]["max"])
	#print("Bois:", resources["wood"]["amount"], "/", resources["wood"]["max"])

# Func qui maj les labels
func update_ui() -> void:
	var relic_text = list_relics()
	var resource_text = ""
	
	for resource_key in resources.keys():
		var res = resources[resource_key]  # Récupère les données de la ressource
		var resource_name = res["name"]  # Récupère le nom de la ressource
		var total_amount = res["amount"] + res["partial"]  # Total affiché
		var max_amount = res["max"]  # Capacité maximale
		var production = res["per_second"] * LootTable.get_relic_bonus(relics, resource_key)  # Production modifiée par les reliques

		# Ajoute la ressource à la chaîne (avec une nouvelle ligne entre chaque ressource)
		resource_text += "%s: %.2f / %d (%.2f/s)\n" % [resource_name, total_amount, max_amount, production]

	# Met à jour le label avec toutes les ressources + les reliques
	$"perma-game_menu/VBoxContainer/gold".text = resource_text + "\n" + relic_text




func add_new_ressource(key: String, name: String, amount: int, max: int, per_second: float, partial: float):
	resources[key] = {
		"name": name,
		"amount": amount,
		"max": max,
		"per_second": per_second,
		"partial": partial
	}


# Func pour améliorer la production (ressource, prix, bonus_prod, quantité max)
func buy_upgrade(resource: String, cost: int, bonus_production: int, bonus_max: int) -> void:
	if resources[resource]["amount"] >= cost:
		resources[resource]["amount"] -= cost
		resources[resource]["per_second"] += bonus_production
		resources[resource]["max"] += bonus_max
		print("Achat effectué ! Nouvelle prod de", resource, ":", resources[resource]["per_second"])
	else:
		print("Pas assez de", resource, "!")

# Func pour lister les reliques
func list_relics() -> String:
	var relic_list = "Relics owned :\n"
	for relic in relics.values():
		relic_list += "- %s (+%.1f%% %s)\n" % [relic["name"], relic["bonus_percent"] * 100, relic["resource"]]
	return relic_list

func _on_exp_finish():
	LootTable.loot_relic(relics)

# Func pour les entrées périphériques
func _input(event):
	
	if Input.is_action_just_pressed("restart"):
		EnvData.full_map_scene = {}
		EnvData.full_map_list = []
		get_tree().reload_current_scene()
	
	if Input.is_action_just_pressed("buy_building"):
		#print(list_relics())
		#buy_upgrade("gold",2,1,5)
		pass
	
	if Input.is_action_just_pressed("expedition"):
		pass
		#LootTable.loot_relic(relics)
	
	#if Input.is_action_pressed("show_hide_map"):
		#add_new_ressource("stone", "Stone", 0, 100, 0.5, 0.0)
