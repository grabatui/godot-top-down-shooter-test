extends Node2D


var laser_projectile_template: Sprite2D


@onready var player_lasers: Node2D = $Lasers


@export var player: Player


func _ready():
    Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

    __set_laser_projectile_template()

    SignalsBus.player_shoot.connect(__on_player_shoot)


func _process(delta):
    for laser in player_lasers.get_children():
        laser.position.y -= player.laser_speed * delta


func __set_laser_projectile_template() -> void:
    laser_projectile_template = Sprite2D.new()
    laser_projectile_template.texture = player.laser_projectile


func __on_player_shoot(marker_position: Vector2) -> void:
    var laser: Sprite2D = laser_projectile_template.duplicate()
    laser.global_position = marker_position

    player_lasers.add_child(laser)
