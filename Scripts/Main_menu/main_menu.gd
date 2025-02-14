extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$bg_music.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# bouton pour passer du main menu au menu options
func _on_options_pressed() -> void:
	$Main_menu.hide()
	$Options_Menu.show()

# bouton pour passer du menu options au main menu
func _on_return_button_pressed() -> void:
	$Options_Menu.hide()
	$Main_menu.show()

# bouton pour passer du main menu au menu play
func _on_play_pressed() -> void:
	$Main_menu.hide()
	$Play_Menu.show()

# bouton pour passer du menu play au main menu
func _on_return_main_play_pressed() -> void:
	$Play_Menu.hide()
	$Main_menu.show()
	


# bouton pour quitter
func _on_quit_pressed() -> void:
	get_tree().quit()
