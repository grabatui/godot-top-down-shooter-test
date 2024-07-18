extends Area2D
class_name Enemy


@export var speed: float = 100.0
@export var points: int = 100


func _on_body_entered(body: Node):
	if body is LaserBody:
		__die(body)


func __die(projectile: LaserBody):
	SignalsBus.enemy_dead.emit(self)

	queue_free()
	projectile.queue_free()
