extends StaticBody2D
class_name LaserBody


@export var direction: int = 1


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
