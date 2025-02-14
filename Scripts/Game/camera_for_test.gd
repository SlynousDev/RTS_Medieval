extends Node

# Paramètres de la caméra orbitale
var rotation_speed: float = 0.003
var distance_speed = 0.003

var zoom_speed: float = 0.5
var min_distance: float = 6.0
var max_distance: float = 30

# Variables internes
var rotation_h: float = 0  # Angle horizontal (autour de l'axe Y)
var rotation_v: float = 0.7  # Angle vertical (autour de l'axe X)
var distance: float = 10.0  # Distance entre la caméra et l'objet

# Valeurs maximales et minimales pour la rotation verticale
var min_rotation_v: float = .3  # Valeur minimale pour la rotation verticale
var max_rotation_v: float = 1.1   # Valeur maximale pour la rotation verticale

# Déplacement latéral
var pan_speed: float = 0.05  # Vitesse du déplacement latéral (augmentée pour plus de visibilité)

# Référence à la caméra
@onready var camera = $"."  # Assurez-vous que le nœud s'appelle bien "Camera"

# Variables pour le déplacement de la caméra
var dragging: bool = false
var last_mouse_pos: Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_camera_position()


func _input(event):
	
	if $"..".visible:
		
		if event is InputEventMouseMotion:
			# Si le bouton gauche est enfoncé
			if Input.is_action_pressed("right_click"):
				rotation_h -= event.relative.x * rotation_speed
				rotation_v += event.relative.y * rotation_speed  # Rotation verticale
				rotation_v = clamp(rotation_v, min_rotation_v, max_rotation_v)  # Limiter la rotation verticale
				_update_camera_position()
			
			elif Input.is_action_pressed("middle_click"):
				var delta = event.relative
				_pan_camera(delta)
				print("Déplacement : ", event.relative.x * distance_speed)

		# Gestion des zooms
		elif event is InputEventMouseButton:
			if Input.is_action_just_pressed("mouse_up"):
				distance = max(min_distance, distance - zoom_speed)
				_update_camera_position()
				#print("distance = ", distance)
				
			elif Input.is_action_just_pressed("mouse_down"):
				distance = min(max_distance, distance + zoom_speed)
				_update_camera_position()
				#print("distance = ", distance)
				
			elif Input.is_action_just_pressed("middle_click"):
				
				pass
				#$".".global_position.x += 0.1
				#print("déplacement : ", $".".global_position)
	else:
		pass

func _pan_camera(delta: Vector2):
	# Calcul du déplacement en fonction de la direction de la caméra
	var right = camera.global_transform.basis.x.normalized() * -delta.x * pan_speed
	var up = camera.global_transform.basis.y.normalized() * delta.y * pan_speed
	camera.position += right + up  # Applique le déplacement

func _update_camera_position():
	if camera:  # Vérification que la caméra existe bien
		# Calcul de la position de la caméra en fonction de l'angle de rotation et de la distance
		var x = distance * cos(rotation_v) * sin(rotation_h)
		var y = distance * sin(rotation_v)
		var z = distance * cos(rotation_v) * cos(rotation_h)

		camera.position = Vector3(x, y, z)  # Utiliser 'position' au lieu de 'translation' en Godot 4
		camera.look_at(Vector3(0, 0, 0), Vector3.UP)

func on_recreate_map():
	distance = 30
	for i in range(22):
		#print("ça zoom")
		await get_tree().create_timer(0.01).timeout
		distance = max(min_distance, distance - 1)
		_update_camera_position()
		
		
