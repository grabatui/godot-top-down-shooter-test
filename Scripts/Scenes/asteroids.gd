extends Node2D


const ASTEROID_ENTER_FROM_IN_SECONDS: float = 0.5
const ASTEROID_ENTER_TO_IN_SECONDS: float = 2.0
const ASTEROID_SPEED_FROM: float = 200.0
const ASTEROID_SPEED_TO: float = 400.0
const ASTEROID_ROTATION_RADIANT_FROM: float = -7.0
const ASTEROID_ROTATION_RADIANT_TO: float = 7.0
const ASTEROID_QUIT_ADDITIONAL: float = 50.0


@onready var asteroids_root: Node2D = $Asteroids
@onready var asteroids_points_root: Node2D = $Points
@onready var asteroids_timer: Timer = $Timer
@onready var full_height: float = float(ProjectSettings.get('display/window/size/viewport_height'))


@export var asteroid_textures: Array[Texture]


var asteroids_generator: RandomNumberGenerator = RandomNumberGenerator.new()


func _ready():
	__start_asteroids_background_timer()


func _process(_delta):
	var asteroids: Array = asteroids_root.get_children()

	for asteroid in asteroids:
		# If we too low, delete asteroid
		if (asteroid.position.y - ASTEROID_QUIT_ADDITIONAL) > full_height:
			asteroid.queue_free()

			continue


func __start_asteroids_background_timer() -> void:
	asteroids_timer.wait_time = asteroids_generator.randf_range(ASTEROID_ENTER_FROM_IN_SECONDS, ASTEROID_ENTER_TO_IN_SECONDS)
	asteroids_timer.start()


func _on_timer_timeout():
	var all_markers: Array = asteroids_points_root.get_children()
	var asteroid_marker: Marker2D = all_markers[randi() % all_markers.size()]

	var asteroid_texture: Texture = asteroid_textures[randi() % asteroid_textures.size()]

	var asteroid: AsteroidSprite2D = AsteroidSprite2D.new()
	asteroid.texture = asteroid_texture
	asteroid.position = asteroid_marker.position
	asteroid.speed = asteroids_generator.randf_range(ASTEROID_SPEED_FROM, ASTEROID_SPEED_TO)
	asteroid.rotation_radiant = asteroids_generator.randf_range(ASTEROID_ROTATION_RADIANT_FROM, ASTEROID_ROTATION_RADIANT_TO)
	asteroid.modulate.a = 0.3

	asteroids_root.add_child(asteroid)

	__start_asteroids_background_timer()
