extends Node

# Func qui retourne la valeur à la position x et y d'une grille
func grid_value(grid, x, y):
	var value
	value = grid[x][y]
	return value

# Func qui retourne true ou false avec 50% pour chacun
func rnd_bool() -> bool:
	var rng
	var rng_bool
	rng = randi_range(1,2)
	if rng == 1:
		rng_bool = true
	if rng == 2:
		rng_bool = false
	return rng_bool

# Func qui retourne true ou false avec un pourcentage sécifique pour true
func rnd_percent_bool(percent: float) -> bool:
	var rng_bool
	if percent > 1.0:
		#print("Pourcentage trop grand")
		rng_bool = false
		return rng_bool
	else:
		var rng = randf_range(0.0, 1.0)
		if rng <= percent:
			#print("Oui ", rng, " est plus petit que ", percent)
			rng_bool = true
		else:
			#print("Non ", rng, " est plus grand que ", percent)
			rng_bool = false
		return rng_bool


# Func Permet de calculer la distance de manhattan entre 2 vecteur2i
func manhattan_distance(pos1: Vector2i, pos2: Vector2i) -> int:
	return abs(pos1.x - pos2.x) + abs(pos1.y - pos2.y)

# Func Permet de calculer la distance de manhattan entre 2 vecteur3i
func manhattan_distance_3D(pos1: Vector3i, pos2: Vector3i) -> int:
	return abs(pos1.x - pos2.x) + abs(pos1.y - pos2.y) + abs(pos1.z - pos2.z)
	
