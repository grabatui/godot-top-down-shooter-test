extends Control


func _on_continue_game_button_button_down():
	SignalsBus.game_menu_button_continue_pressed.emit()


func _on_quit_button_button_down():
	get_tree().quit()
