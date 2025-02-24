extends Node

# Temps en minutes dans la journée (0 à 1440 pour une durée de 24h)
# 0 = 12h, 360 = 18h, 720 = 24h, 1080 = 6h

var current_time: float = 0.0 # Le temps actuel
var day_time: float = 1440.0 # le temps max d'une journée
var time_speed: float = 200.0 # vitesse à laquelle s'écoule le temps (1.0 = 1 minutes dans le jeu pour 1 séconde dans la réalité
var last_checked_hour: int = -1  # Stocke la dernière heure vérifiée
var day_change_hour: int = 6  # Heure à laquelle un nouveau jour commence (ex: 6h du matin)
var add_time = false

var full_time = "%02d:%02d" % []
var total_day = 0
var time_cycle = "jour" # soit "jour" soit "nuit"


# Cycle de la lune = 8, en 8 jours
var all_moon_phase = ["new moon", "waxing crescent", "first quarter", "waxing gibbous", "full moon", "waning gibbous", "last quarter", "waning crescent"]
var current_moon_phase = 0
var lunar_phase: String = all_moon_phase[current_moon_phase]  # Phase initiale



var current_weather: String = "Clear"
var main_weather = ["Clear", "Overcast", "Rainy", "Stormy", "Foggy", "Snowy", "Windy"]
var weather_probabilities = {  # Probabilités d'apparition si on change le temps, tout doit être égal à 100
	"Clear": 50,   # Favorisé
	"Overcast": 15,
	"Rainy": 10,
	"Stormy": 5,
	"Foggy": 10,
	"Snowy": 5,
	"Windy": 5
}

var weather_event = ["Blood moon", "Solar eclipse", "Blue moon"]
var current_weather_event = "No"

# Func qui permet de mettre à jour l'heure in-game
func update_time(delta: float):
	get_cycle_time()
	current_time += delta * time_speed
	if current_time >= day_time:
		current_time = 0
		
		
	var new_hour = int(full_time.split(":")[0])
	
	if new_hour != last_checked_hour:
		last_checked_hour = new_hour
		add_time = false
		change_weather()
	
	# Changement de jour
	if new_hour == day_change_hour:
		if add_time == false:
			total_day += 1  # Incrémente le nombre total de jours
			current_moon_phase += 1
			if current_moon_phase >= 8:
				current_moon_phase = 0
			lunar_phase = all_moon_phase[current_moon_phase]
			add_time = true
			choose_weather_event()
			print("phase lunaire : ", lunar_phase)
	
	# Indique le jour et la nuit
	if new_hour >= 21 or new_hour < 6:
		time_cycle = "nuit"
	else:
		time_cycle = "jour"


# Func qui permet de savoir si on change de météo
func change_weather():
	if randf() < 0.4: # 40% de chance de changer de temps
		current_weather = choose_weather()
	else:
		current_weather = "Clear"
	
	print("current_weather = ", current_weather)

# Func qui permet de choisir et de retourner une météo dans weather_probabilities
func choose_weather() -> String:
	var weighted_list = []
	for weather in weather_probabilities:
		for _i in range(weather_probabilities[weather]):
			weighted_list.append(weather)
	
	return weighted_list[randi() % weighted_list.size()]  # Choix pseudo-aléatoire


func choose_weather_event():
	if randf() < 0.1: # 10% de chance de faire apparaître un weather event
		current_weather_event = randi_range(0, len(weather_event))
		current_weather_event = weather_event[current_weather_event]
	else :
		current_weather_event = "No"
	print("current_weather_event = ", current_weather_event)


func add_weather_event():
	if current_weather_event == "No":
		pass
	if current_weather_event == "Blood moon":
		pass


func stop_weather_event():
	current_weather_event == "No"
# Func qui permet de mettre à jour full_time
func get_cycle_time():
	var converted_current_time = (current_time * 24)/day_time
	var heure = int(converted_current_time)
	var minutes = int((converted_current_time - heure)*60)
	
	var supposed_hour = heure + 12
	if supposed_hour >= 24:
		heure -= 12
	else:
		heure += 12
	full_time = "%02d:%02d" % [heure, minutes]
