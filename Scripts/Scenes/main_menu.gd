extends Control


func _on_start_game_button_button_down():
	get_tree().change_scene_to_file('res://Scenes/world.tscn')


func _on_quit_button_button_down():
	get_tree().quit()
