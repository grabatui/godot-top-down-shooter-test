extends Node2D


const BACKGROUND_SPEED: float = 200.0


@export var background_texture: Texture


@onready var full_width: float = float(ProjectSettings.get('display/window/size/viewport_width'))
@onready var full_height: float = float(ProjectSettings.get('display/window/size/viewport_height'))


var template: Sprite2D
var background_size_quarter: float


func _ready():
	__set_background_part_template()
	__fill_background()


func _process(delta):
	__process_main_background(delta)


func __process_main_background(delta: float) -> void:
	var background_children: Array = self.get_children()

	var minimum_top: float
	for child in background_children:
		# If we too low, delete background nodes
		if (child.position.y - (background_size_quarter * 2)) > full_height:
			child.queue_free()

			continue

		child.position.y += BACKGROUND_SPEED * delta

		minimum_top = min(minimum_top, child.position.y)

	# If top children too low, add new background nodes on the top
	if minimum_top <= 0 and minimum_top > (-1 * background_size_quarter):
		__add_backgound_parts(minimum_top + (5 * delta) - (background_size_quarter * 2))


func __set_background_part_template() -> void:
	template = Sprite2D.new()
	template.texture = background_texture
	template.scale.x = (full_width / 2) / template.texture.get_width()
	template.scale.y = template.scale.x

	background_size_quarter = full_width / 4


func __fill_background() -> void:
	var current_height_position: float = background_size_quarter - background_size_quarter - background_size_quarter

	__add_backgound_parts(current_height_position - current_height_position)

	while true:
		__add_backgound_parts(current_height_position)

		if current_height_position > full_height:
			break

		current_height_position += background_size_quarter * 2


func __add_backgound_parts(current_height_position: float) -> void:
	var part_left: Sprite2D = template.duplicate() as Sprite2D
	part_left.position = Vector2(background_size_quarter, current_height_position)
	self.add_child(part_left)

	var part_right: Sprite2D = template.duplicate() as Sprite2D
	part_right.position = Vector2(background_size_quarter * 3, current_height_position)
	self.add_child(part_right)
