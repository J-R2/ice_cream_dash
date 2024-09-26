## Moves a cloud sprite across the screen in a loop
extends Node2D

# Can potentially have different cloud sprites
@export var texture :Texture2D = preload("res://scenes/background_scene/art/cloud.png")

func _ready() -> void:
	$Sprite.texture = texture
	$Sprite2.texture = texture
