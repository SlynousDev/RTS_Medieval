extends Control

@onready var scene_tree = get_tree()

@onready var time: Label = $"weather-time/Time"


func _on_go_to_castle_pressed() -> void:
	WeatherData.get_cycle_time()
	scene_tree.change_scene_to_file("res://Scenes/Game/main_castle.tscn")
	
func _process(delta: float) -> void:
	time.text = "%s / %s" % [WeatherData.full_time, WeatherData.total_day]
