extends CharacterBody2D
class_name Player


const INITIAL_LASER_SPEED = 400.0
const INITIAL_SHOOT_SECONDS_INTERVAL = 1.3
const ADDITIONAL_BORDER = 10.0


@onready var player_sprite: Sprite2D = $PlayerShip3Blue
@onready var shoot_marker: Marker2D = $ShootMarker
@onready var shoot_timer: Timer = $ShootTimer


@export var laser_speed: float = INITIAL_LASER_SPEED
@export var shoot_seconds_interval: float = INITIAL_SHOOT_SECONDS_INTERVAL
@export var laser_projectile: Texture


var player_size: Vector2
var left_border: float
var right_border: float

var shoot_wait: bool = false


func _ready():
	player_size = player_sprite.texture.get_size()
	left_border = (player_size.x / 2) + ADDITIONAL_BORDER
	right_border = (ProjectSettings.get('display/window/size/viewport_width') - (player_size.x / 2)) - ADDITIONAL_BORDER


func _process(_delta):
	if Input.is_action_pressed('shoot') and not shoot_wait:
		SignalsBus.player_shoot.emit(shoot_marker.global_position)

		__start_shoot_timer()


func _physics_process(_delta):
	var mouse_position: Vector2 = get_global_mouse_position()
	
	position = Vector2(mouse_position.x, position.y)

	# Do not move out borders
	if mouse_position.x > right_border and position.x >= right_border:
		position = Vector2(right_border, position.y)
	elif mouse_position.x < left_border and position.x <= left_border:
		position = Vector2(left_border, position.y)

	move_and_slide()


func __start_shoot_timer() -> void:
	shoot_timer.wait_time = shoot_seconds_interval
	shoot_timer.start()

	shoot_wait = true


func _on_shoot_timer_timeout():
	shoot_wait = false
