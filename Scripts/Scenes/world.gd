extends Node2D


const LASER_QUIT_ADDITIONAL: float = 50.0


var laser_projectile_template: Sprite2D


@onready var lasers: Node2D = $Lasers
@onready var menu: CanvasLayer = $Menu
@onready var scenario: Scenario = $Scenario
@onready var enemy_paths: Node2D = $EnemyPaths
@onready var enemy_templates: Node2D = $AllEnemies
@onready var path_templates: Node2D = $Paths
@onready var score: Label = $Interface/%GlobalScore


@export var player: Player


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)

	__set_laser_projectile_template()
	__set_enemies()

	SignalsBus.player_shoot.connect(__on_player_shoot)
	SignalsBus.enemy_shoot.connect(__on_enemy_shoot)
	SignalsBus.game_menu_button_continue_pressed.connect(__on_menu_continue_pressed)
	SignalsBus.player_dead.connect(__on_player_dead)
	SignalsBus.enemy_dead.connect(__on_enemy_dead)


func _process(delta):
	for laser in lasers.get_children():
		laser.position.y -= player.laser_speed * delta * laser.direction

		if laser.position.y < (-1 * LASER_QUIT_ADDITIONAL) or (laser.position.y > get_viewport_rect().size.y + LASER_QUIT_ADDITIONAL):
			laser.queue_free()

	for enemy_path in enemy_paths.get_children():
		for enemy_path_follow in enemy_path.get_children():
			if enemy_path_follow is PathFollow2D:
				for enemy in enemy_path_follow.get_children():
					enemy_path_follow.progress += enemy.speed * delta


func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			__show_menu()


func __set_laser_projectile_template() -> void:
	laser_projectile_template = Sprite2D.new()
	laser_projectile_template.texture = player.laser_projectile


func __set_enemies() -> void:
	var enemy_path: Path2D
	var path_follow: PathFollow2D
	var enemy_entity: Enemy
	for scenario_path in scenario.paths:
		enemy_path = path_templates.get_node(scenario_path.path).duplicate()
		enemy_path.show()

		enemy_paths.add_child(enemy_path)

		for i in range(scenario_path.count):
			path_follow = PathFollow2D.new()
			path_follow.rotates = false
			path_follow.loop = false

			enemy_path.add_child(path_follow)

			enemy_entity = enemy_templates.get_node(scenario_path.enemy).duplicate()
			enemy_entity.show()

			path_follow.add_child(enemy_entity)

			if i < scenario_path.count:
				await __wait_for_seconds(scenario_path.delay_between_enemies)

		await __wait_for_seconds(scenario_path.delay_between_paths)


func __show_menu() -> void:
	menu.show()

	get_tree().paused = true
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)


func __on_player_shoot(marker_position: Vector2) -> void:
	var laser: LaserBody = player.laser_body.instantiate()
	var laser_sprite: Sprite2D = laser_projectile_template.duplicate()

	laser.add_child(laser_sprite)
	laser.global_position = marker_position

	lasers.add_child(laser)


func __on_enemy_shoot(enemy: Enemy) -> void:
	var laser: LaserBody = enemy.laser_body.instantiate()
	var laser_sprite: Sprite2D = enemy.laser_projectile_template.duplicate()

	laser_sprite.flip_v = true

	laser.direction = -1
	laser.add_child(laser_sprite)
	laser.global_position = enemy.shoot_marker.global_position

	lasers.add_child(laser)


func __on_menu_continue_pressed() -> void:
	menu.hide()

	get_tree().paused = false

	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)


func __on_player_dead() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

	get_tree().change_scene_to_file('res://Scenes/main_menu.tscn')


func __on_enemy_dead(enemy: Enemy) -> void:
	Globals.score += enemy.points

	score.text = str(Globals.score)


func __wait_for_seconds(seconds: float) -> Signal:
	return get_tree().create_timer(seconds).timeout
