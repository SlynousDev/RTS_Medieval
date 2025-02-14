extends Camera2D


# Limites du déplacement (en fonction de ton viewport)
var coords_pos = 120
var min_position = Vector2(-coords_pos, -coords_pos)  # Limite inférieure (coin supérieur gauche)
var max_position = Vector2(coords_pos,coords_pos)  # Limite supérieure (coin inférieur droit)
var dragging = false
var cell_size = Vector2(16,16)

var last_mouse_pos = Vector2.ZERO
var zoom_speed = 1.1  # Facteur de zoom
var min_zoom = 0.8
var max_zoom = 4.0

@onready var square = $"../Square"
@onready var full_map = $"../.."

func _ready() -> void:
	print(Vector2(5,5)*0.9)

func _input(event):

	if Input.is_action_just_pressed("mouse_up") and full_map.visible:
		if (square.scale * 1.1) > Vector2(max_zoom,max_zoom) :
			pass
		else:
			square.scale *= 1.1
			coords_pos *= 1.1
			min_position = Vector2(-coords_pos, -coords_pos)
			max_position = Vector2(coords_pos,coords_pos)
		print(square.scale)
	if Input.is_action_just_pressed("mouse_down") and full_map.visible:
		if (square.scale * 0.9) < Vector2(min_zoom,min_zoom) :
			pass
		else:
			square.scale *= 0.9
			coords_pos *= 0.9
			min_position = Vector2(-coords_pos, -coords_pos)
			max_position = Vector2(coords_pos,coords_pos)
		print(square.scale)



func _process(_delta):
	# 🎯 Déplacement au clic droit
	if Input.is_action_just_pressed("middle_click"):
		dragging = true
		last_mouse_pos = get_viewport().get_mouse_position()

	elif Input.is_action_just_released("middle_click"):
		dragging = false

	if dragging and Input.is_action_pressed("middle_click"):
		var mouse_pos = get_viewport().get_mouse_position()
		var delta = last_mouse_pos - mouse_pos  # Inversé pour un déplacement naturel
		square.position -= delta  # Déplace la caméra
		last_mouse_pos = mouse_pos  # Mise à jour de la position
		
		# Limiter la position de la TileMap pour ne pas dépasser les bords
		# Limite horizontale (gauche/droite)
		square.position.x = clamp(square.position.x, min_position.x, max_position.x)
		
		# Limite verticale (haut/bas)
		square.position.y = clamp(square.position.y, min_position.y, max_position.y)
