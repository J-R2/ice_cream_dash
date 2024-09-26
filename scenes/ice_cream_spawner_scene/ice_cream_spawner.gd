## Spawns an ice cream scoop just above the screen bounds
## Randomly spawns cherries
extends Node2D

const ICE_CREAM_SCENE = preload("res://scenes/ice_cream_scene/ice_cream.tscn")
const CHERRY_SCENE = preload("res://scenes/ice_cream_scene/cherry_scene/cherry.tscn")


# get the screen bounds
@onready var screen_size :Vector2 = get_viewport_rect().size
@onready var min_marker_x :int = 50 # marks the left side of the screen to spawn an item
@onready var max_marker_x :int = screen_size.x - 50 # marks the right side of the screen to spawn an item
@onready var timer: Timer = $Timer ## when timeout, spawn an ice cream
## spawn_marker moves to a random position inside the x bounds of the screen, just above the viewport (out of view for spawing)
## it marks the initial position of the ice cream instance
@onready var spawn_marker :Marker2D = $SpawnMarker


func _ready() -> void :
	timer.timeout.connect(_on_timer_timeout)
	reset_timer()


## Spawns an ice cream, with a chance to spawn cherries, and resets the timer
func _on_timer_timeout() -> void :
	randomize()
	if randi_range(0, 100) < 35: # 35% chance of spawning cherries on timeout
		spawn_cherry()
	spawn_ice_cream()
	reset_timer()


## Moves the spawner_marker and instance a cherry at that position
func spawn_cherry() -> void :
	move_spawner()
	var cherry = CHERRY_SCENE.instantiate()
	cherry.position = spawn_marker.position
	get_parent().add_child(cherry)


## Moves the spawner_marker and instance an ice cream at that position
func spawn_ice_cream() -> void : 
	move_spawner()
	var ice_cream = ICE_CREAM_SCENE.instantiate()
	ice_cream.position = spawn_marker.position
	get_parent().add_child(ice_cream)


## Randomizes the timer wait_time and start countdown to next spawn
func reset_timer() -> void : 
	timer.stop()
	randomize()
	timer.wait_time = randf_range(.3, 1)
	timer.start()


## Moves the Marker2D to a random position above the screen bounds
func move_spawner() -> void :
	randomize()
	var spawn_point := Vector2(randi_range(min_marker_x, max_marker_x), position.y)
	spawn_marker.position = spawn_point
