extends Area2D

# Emits the total amount of ice cream scoops on the stack
signal scoops_added(amount:int) ## Emitted when the player touches a ice cream scoop to update score
signal game_over ## Emitted when the player touches a cherry

# Get the screen size
@onready var screen_size :Vector2 = get_viewport_rect().size
## The left side of the screen bounds
@onready var min_marker_x :int = 35
## The right side of the screen bounds
@onready var max_marker_x :int = screen_size.x - 35
## The collider that detects ice creams and cherries
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


var speed = 600 ## The player speed
var is_moving_down = false ## is the stack moving down to make room to collect more
var scoops = [] ## The array of items on the stack
var direction := Vector2.ZERO ## The player input direction
var y_marker : int = 0 ## Holds the bottom screen marker for moving the stack down


func _ready() -> void:
	self.area_entered.connect(_on_area_entered)
	self.game_over.connect(_on_game_over)
	y_marker = screen_size.y - 55  # The bottom y-bound, where the player initially spawns
	# Set the player position to the bottom center of the screen
	position.y = y_marker
	position.x = max_marker_x / 2


func _process(delta: float) -> void:
	if not is_moving_down:
		# Mouse moves the player
		#direction = Vector2(get_global_mouse_position().x, position.y)
		#position = direction
		# Arrow keys move the player
		direction = Vector2(Input.get_axis("ui_left", "ui_right"), 0)
		var velocity = speed * direction
		position += velocity * delta
		# Keep the x position inside the screen bounds
		position.x = clamp(position.x, min_marker_x, max_marker_x)
	if not scoops.is_empty():
		# Move the first scoop with the player cone
		scoops[0].position.x = position.x 
		# Move the collider to the top of the stack to catch items
		collision_shape_2d.global_position.x = scoops[-1].global_position.x 
	# sway the stack of ice cream
	if scoops.size() > 1 :
		sway()
	if collision_shape_2d.global_position.y < screen_size.y / 3:
		move_down()
		

func move_down() -> void:
	is_moving_down = true
	collision_shape_2d.disabled = true
	var tween = create_tween()
	var duration :float = 2.0
	tween.set_parallel(true)
	var offset = (y_marker - collision_shape_2d.global_position.y) / 2
	tween.tween_property(self, "position:y", position.y + offset, duration)
	for i in range(scoops.size()):
		tween.tween_property(scoops[i], "position:y", scoops[i].position.y + offset, duration)
	tween.finished.connect(func() -> void :
		is_moving_down = false
		collision_shape_2d.disabled = false
	)
	
	
	
## sways the ice cream stack left and right
func sway():
	var duration : float = .01
	for index in range(1, scoops.size()):
		var tween = create_tween()
		if direction == Vector2.ZERO:
			duration = 0.03
		tween.tween_property(scoops[index], "position:x", scoops[index-1].position.x, duration)


## add the ice cream to the scoops stack when you touch it, disable the ice cream's falling
func _on_area_entered(area :Area2D) -> void:
	audio_stream_player.play()
	if (area is IceCream) and (area not in scoops):
		area.is_falling = false # disable ice cream falling
		scoops.append(area) # add ice cream to scoop stack
		# place the scoop at the collision shape's y coord (even stacking of the scoops)
		area.position.y = collision_shape_2d.global_position.y
		collision_shape_2d.global_position.y = scoops[-1].position.y - 30
		scoops_added.emit(scoops.size())
	if area is Cherry:
		scoops.append(area)
		game_over.emit()
		

func _on_game_over() -> void:
	var cherries = get_tree().get_nodes_in_group("cherry")
	var ice_cream = get_tree().get_nodes_in_group("ice_cream")
	for node in cherries:
		if node not in scoops:
			node.queue_free()
	for node in ice_cream:
		if node not in scoops:
			node.queue_free()

