extends CharacterBody2D
class_name Player


const INITIAL_SPEED = 150.0
const INITIAL_LASER_SPEED = 400.0
const ADDITIONAL_BORDER = 10.0


@onready var player_sprite: Sprite2D = $PlayerShip3Blue
@onready var shoot_marker: Marker2D = $ShootMarker


@export var speed: float = INITIAL_SPEED
@export var laser_speed: float = INITIAL_LASER_SPEED
@export var laser_projectile: Texture


var player_size: Vector2
var left_border: float
var right_border: float


func _ready():
	player_size = player_sprite.texture.get_size()
	left_border = (player_size.x / 2) + ADDITIONAL_BORDER
	right_border = (ProjectSettings.get('display/window/size/viewport_width') - (player_size.x / 2)) - ADDITIONAL_BORDER


func _process(_delta):
	if Input.is_action_just_pressed('shoot'):
		SignalsBus.player_shoot.emit(shoot_marker.global_position)


func _physics_process(delta):
	var mouse_position: Vector2 = get_global_mouse_position()

	velocity = Vector2(mouse_position.x - global_position.x, 0) * (speed * delta)

	# Do not move out borders
	if (mouse_position.x > right_border and position.x >= right_border) or (mouse_position.x < left_border and position.x <= left_border):
		velocity = Vector2.ZERO

	move_and_slide()

