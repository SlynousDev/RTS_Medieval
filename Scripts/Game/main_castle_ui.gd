extends Control

@onready var scene_tree = get_tree()

func _on_back_to_lobby_pressed() -> void:
	scene_tree.change_scene_to_file("res://Scenes/Game/game.tscn")
