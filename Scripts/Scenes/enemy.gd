extends Area2D
class_name Enemy


var laser_projectile_template: Sprite2D


@onready var shoot_marker: Marker2D = $ShootMarker
@onready var shoot_timer: Timer = $ShootTimer


@export var speed: float = 100.0
@export var points: int = 100
@export var can_shoot: bool = false
@export var shoot_speed: float = 0.0
@export var laser_projectile: Texture
@export var laser_body: PackedScene


func _ready():
	__set_laser_projectile_template()

	if self.visible and can_shoot and shoot_speed >= 0.0:
		__start_shoot()


func _on_body_entered(body: Node):
	if body is LaserBody:
		__die(body)


func _on_shoot_timer_timeout():
	SignalsBus.enemy_shoot.emit(self)


func __die(projectile: LaserBody) -> void:
	SignalsBus.enemy_dead.emit(self)

	queue_free()
	projectile.queue_free()


func __start_shoot() -> void:
	shoot_timer.wait_time = shoot_speed
	shoot_timer.start()


func __set_laser_projectile_template() -> void:
	laser_projectile_template = Sprite2D.new()
	laser_projectile_template.texture = laser_projectile
