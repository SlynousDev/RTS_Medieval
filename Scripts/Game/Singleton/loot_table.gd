extends Node
# La table de loot, le total de chance doit faire 1.0 = 100%

# Compteur de reliques
var common_relics = 0
var rare_relics = 0
var epic_relics = 0
var legendary_relics = 0


var rarity = {
	"common" : 70,
	"rare" : 15,
	"epic" : 10,
	"legendary" : 5
}

# Func pour obtenir une rareté
func get_rarity():
	var rng_rarity = RandomNumberGenerator.new()
	var weight_sum = 0
	
	for n in rarity:
		weight_sum += rarity[n]
	var item = rng_rarity.randi_range(0,weight_sum)
	for n in rarity:
		if item <= rarity[n]:
			return n
		item -= rarity[n]

# Table de loot pour expéditions
var loot_exp = {
	"old man": {"name": "Vielle personne"},
	"mystery_box": {"name": "Coffre Mystérieux", "resource": "gold", "bonus_percent": 0.0},
}

# Table de loot pour reliques communes
var loot_relics_common = {
	"ruby": {"name": "Rubi", "resource": "gold", "bonus_percent": 0.02},
	"gold_pile": {"name": "Tas d'or", "resource": "gold", "bonus_percent": 0.02},
	"gold_purse": {"name": "Bourse d'or", "resource": "gold", "bonus_percent": 0.02},
}

# Table de loot pour reliques rare
var loot_relics_rare = {
	"golden_statue": {"name": "Statue Dorée", "resource": "gold", "bonus_percent": 0.04},
	"ancient_scroll": {"name": "Parchemin Ancien", "resource": "gold", "bonus_percent": 0.04},
	"mystic_gem": {"name": "Gemme Mystique", "resource": "gold", "bonus_percent": 0.04},
}
# Table de loot pour reliques epique
var loot_relics_epic = {
	"diamond_ring": {"name": "Bague en diamant", "resource": "gold", "bonus_percent": 0.08},
	"gold_ball": {"name": "Sphère d'or", "resource": "gold", "bonus_percent": 0.08},
	"mini_rainbow": {"name": "Arc-en-ciel miniature", "resource": "gold", "bonus_percent": 0.08},
}
# Table de loot pour reliques legendaire
var loot_relics_legendary = {
	"gold_funtain": {"name": "Fontaine d'or", "resource": "gold", "bonus_percent": 0.12},
	"precious_skull": {"name": "Crâne précieux", "resource": "gold", "bonus_percent": 0.12},
	"philosopher_stone": {"name": "Pierre philosophale", "resource": "gold", "bonus_percent": 0.12},
}

# Func pour les bonus accordé grâce aux reliques
func get_relic_bonus(relics: Dictionary, resource: String) -> float:
	var bonus = 1.0  # Base 100% (pas de bonus)
	for relic in relics.values():
		if relic["resource"] == resource:
			bonus += relic["bonus_percent"]  # Ajoute le pourcentage en tant que multiplicateur
	return bonus

# Func pour ajouter une nouvelle reliques
func add_new_relic(relicss: Dictionary, key: String, name: String, resource: String, bonus_percent: float):
	relicss[key] = {
		"name": name,
		"resource": resource,
		"bonus_percent": bonus_percent
	}

func loot_relic(relic_tab: Dictionary):
	print("=============================")
	var get_rarity = LootTable.get_rarity()
	
	if get_rarity == "common":
		while true:
			var loot = LootTable.get_loot_relics(LootTable.loot_relics_common)
			if loot[0] in relic_tab and common_relics <= len(LootTable.loot_relics_common):
				print("On reroll")
				if common_relics == len(LootTable.loot_relics_common):
					print("Toute les reliques Communes ont été récupérées !! Prenez ces ressources à la place")
					break
			else:
				print(loot[1].get("name"), ", et voici loot[0] : ", loot[0])
				common_relics += 1
				LootTable.add_new_relic(relic_tab, loot[0], loot[1].get("name"), loot[1].get("resource"), loot[1].get("bonus_percent"))
				break
	
	if get_rarity == "rare":
		while true:
			var loot = LootTable.get_loot_relics(LootTable.loot_relics_rare)
			if loot[0] in relic_tab and rare_relics <= len(LootTable.loot_relics_rare):
				print("On reroll")
				if rare_relics == len(LootTable.loot_relics_rare):
					print("Toute les reliques Rares ont été récupérées !! Prenez ces ressources à la place")
					break
			else:
				print(loot[1].get("name"), ", et voici loot[0] : ", loot[0])
				rare_relics += 1
				LootTable.add_new_relic(relic_tab, loot[0], loot[1].get("name"), loot[1].get("resource"), loot[1].get("bonus_percent"))
				break
	
	if get_rarity == "epic":
		while true:
			var loot = LootTable.get_loot_relics(LootTable.loot_relics_epic)
			if loot[0] in relic_tab and epic_relics <= len(LootTable.loot_relics_epic):
				print("On reroll")
				if epic_relics == len(LootTable.loot_relics_epic):
					print("Toute les reliques Épiques ont été récupérées !! Prenez ces ressources à la place")
					break
			else:
				print(loot[1].get("name"), ", et voici loot[0] : ", loot[0])
				epic_relics += 1
				LootTable.add_new_relic(relic_tab, loot[0], loot[1].get("name"), loot[1].get("resource"), loot[1].get("bonus_percent"))
				break
	
	if get_rarity == "legendary":
		while true:
			var loot = LootTable.get_loot_relics(LootTable.loot_relics_legendary)
			if loot[0] in relic_tab and legendary_relics <= len(LootTable.loot_relics_legendary):
				print("On reroll")
				if legendary_relics == len(LootTable.loot_relics_legendary):
					print("Toute les reliqes Légendaire ont été récupérées !! Prenez ces ressources à la place")
					break
			else:
				print(loot[1].get("name"), ", et voici loot[0] : ", loot[0])
				legendary_relics += 1
				LootTable.add_new_relic(relic_tab, loot[0], loot[1].get("name"), loot[1].get("resource"), loot[1].get("bonus_percent"))
				break


# Fonction pour tirer un loot aléatoire dans une table
func get_loot_relics(table: Dictionary) -> Array:
	var keys = table.keys()
	var random_key = keys[randi() % keys.size()]
	#print("la random key : ", random_key)
	var total = [random_key, table[random_key]]
	return total
