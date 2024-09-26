## A Cherry sprite that falls until it reaches the stack or out of bounds
class_name Cherry
extends Area2D

# Get the screen size
@onready var screen_size :Vector2 = get_viewport_rect().size
# The y-marker to check if cherry has fallen below the screen bounds
@onready var below_screen_y = screen_size.y + 200
@export var speed = 500 ## the speed at which the cherry falls
var is_falling :bool = true # is the cherry falling

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed = randi_range(400, 600)

# Make the cherry fall and queue_free if below the screen
func _process(delta: float) -> void:
	if is_falling == true:
		position.y += speed * delta
	if (position.y > below_screen_y) and (is_falling == true):
		queue_free()
