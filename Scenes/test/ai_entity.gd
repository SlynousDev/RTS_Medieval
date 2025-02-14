extends CharacterBody3D

@export var movement_speed: float = 4.0
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var exitpoint: Node3D = $"../exitpoint"

func _ready():
	navigation_agent.velocity_computed.connect(_on_velocity_computed)
	set_movement_target(exitpoint.global_position)
	
# Définir une position cible
func set_movement_target(target_position: Vector3):
	navigation_agent.set_target_position(target_position)
	
	
func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		print("Terminé")
		return
	
	var next_path_position = navigation_agent.get_next_path_position()
	print("Prochaine pos : ", next_path_position)
	
	# Garder l'IA au sol
	next_path_position.y = global_position.y 
	
	var new_velocity = global_position.direction_to(next_path_position) * movement_speed
	new_velocity.y = 0
	navigation_agent.velocity = new_velocity
	
	

# Appliquer le déplacement en évitant les collisions
func _on_velocity_computed(safe_velocity: Vector3):
	velocity = safe_velocity
	move_and_slide()

func _input(event):
	if Input.is_action_just_pressed("expedition"):
		print("Je bouge !")
		var random_posx = randi_range(-4,4)
		var random_posz = randi_range(-4,4)
		set_movement_target(Vector3(0, 0, 0))
