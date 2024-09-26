extends Node2D

@export var texture :Texture2D = preload("res://scenes/parallax_background_scene/art/cloud.png")

func _ready() -> void:
	$Sprite.texture = texture
	$Sprite2.texture = texture
