extends Node2D


const LASER_QUIT_ADDITIONAL: float = 50.0


var laser_projectile_template: Sprite2D
var shooting_enabled: bool = false


@onready var player_lasers: Node2D = $Lasers
@onready var menu: CanvasLayer = $Menu


@export var player: Player


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)

	__set_laser_projectile_template()

	SignalsBus.player_shoot.connect(__on_player_shoot)
	SignalsBus.game_menu_button_continue_pressed.connect(__on_menu_continue_pressed)


func _process(delta):
	for laser in player_lasers.get_children():
		laser.position.y -= player.laser_speed * delta

		if laser.position.y < (-1 * LASER_QUIT_ADDITIONAL):
			laser.queue_free()


func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			__show_menu()


func __set_laser_projectile_template() -> void:
	laser_projectile_template = Sprite2D.new()
	laser_projectile_template.texture = player.laser_projectile


func __on_player_shoot(marker_position: Vector2) -> void:
	if not shooting_enabled:
		return

	var laser: Sprite2D = laser_projectile_template.duplicate()
	laser.global_position = marker_position

	player_lasers.add_child(laser)


func __show_menu() -> void:
	menu.show()

	get_tree().paused = true
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)


func __on_menu_continue_pressed() -> void:
	menu.hide()

	get_tree().paused = false

	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)


func _on_enable_shooting_timer_timeout():
	shooting_enabled = true
