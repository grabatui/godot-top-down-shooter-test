extends Sprite2D
class_name AsteroidSprite2D


var speed: float
var rotation_radiant: float


func _process(delta):
    position.y += speed * delta
    
    rotate(rotation_radiant * delta)
