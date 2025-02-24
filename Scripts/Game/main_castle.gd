extends Node

@onready var sun: DirectionalLight3D = $NavigationRegion3D/DirectionalLight3D

func _process(delta: float) -> void:
	WeatherData.update_time(delta)
	
	sun.rotation_degrees.x =lerp(-90,270, WeatherData.current_time/WeatherData.day_time)
	#print("le temps : ", WeatherData.current_time)


# item 0 : y = -0.031
# item 1 : 
# item 2 : y = -0.5
# item 3 : y = 0.75
# item 4 : y = -0.5
# item 5 : y = -0.5
# item 6 : y = -0.5
# item 7 : y = -0.5
# item 8 : y = -0.5
