extends Area2D
class_name Enemy


@export var speed: float = 100.0


func _ready():
	pass


func _process(_delta):
	pass


func _on_body_entered(body: Node):
	if body is LaserBody:
		queue_free()
		body.queue_free()
