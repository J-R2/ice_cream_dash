class_name IceCream
extends Area2D

## Array of the different ice cream scoop textures
const FLAVORS = [
		preload("res://scenes/ice_cream_scene/art/ice_cream/base.png"),
		preload("res://scenes/ice_cream_scene/art/ice_cream/ice_cream_apple.png"), 
		preload("res://scenes/ice_cream_scene/art/ice_cream/ice_cream_bluemoon.png"),
		preload("res://scenes/ice_cream_scene/art/ice_cream/ice_cream_caramel.png"), 
		preload("res://scenes/ice_cream_scene/art/ice_cream/ice_cream_cassis.png"), 
		preload("res://scenes/ice_cream_scene/art/ice_cream/ice_cream_charcoal.png"), 
		preload("res://scenes/ice_cream_scene/art/ice_cream/ice_cream_cherry.png"), 
		preload("res://scenes/ice_cream_scene/art/ice_cream/ice_cream_chili.png"), 
		preload("res://scenes/ice_cream_scene/art/ice_cream/ice_cream_chips.png"), 
		preload("res://scenes/ice_cream_scene/art/ice_cream/ice_cream_choco.png"), 
		preload("res://scenes/ice_cream_scene/art/ice_cream/ice_cream_chocomilk.png"), 
		preload("res://scenes/ice_cream_scene/art/ice_cream/ice_cream_coconut.png"), 
		preload("res://scenes/ice_cream_scene/art/ice_cream/ice_cream_coffee.png"), 
		preload("res://scenes/ice_cream_scene/art/ice_cream/ice_cream_cottoncandy.png"), 
		preload("res://scenes/ice_cream_scene/art/ice_cream/ice_cream_lime.png"),
		preload("res://scenes/ice_cream_scene/art/ice_cream/ice_cream_mango.png"), 
		preload("res://scenes/ice_cream_scene/art/ice_cream/ice_cream_maple.png"), 
		preload("res://scenes/ice_cream_scene/art/ice_cream/ice_cream_mintchoc.png"), 
		preload("res://scenes/ice_cream_scene/art/ice_cream/ice_cream_moonmist.png"), 
		preload("res://scenes/ice_cream_scene/art/ice_cream/ice_cream_napo.png"), 
		preload("res://scenes/ice_cream_scene/art/ice_cream/ice_cream_oreo.png"), 
		preload("res://scenes/ice_cream_scene/art/ice_cream/ice_cream_pistachio.png"), 
		preload("res://scenes/ice_cream_scene/art/ice_cream/ice_cream_raspberry.png"),
		preload("res://scenes/ice_cream_scene/art/ice_cream/ice_cream_rocky_road.png"),
		preload("res://scenes/ice_cream_scene/art/ice_cream/ice_cream_saffron.png"), 
		preload("res://scenes/ice_cream_scene/art/ice_cream/ice_cream_spumoni.png"), 
		preload("res://scenes/ice_cream_scene/art/ice_cream/ice_cream_strawberry.png"), 
		preload("res://scenes/ice_cream_scene/art/ice_cream/ice_cream_tea.png"), 
		preload("res://scenes/ice_cream_scene/art/ice_cream/ice_cream_ube.png"), 
		preload("res://scenes/ice_cream_scene/art/ice_cream/ice_cream_vanilla.png"), 
		preload("res://scenes/ice_cream_scene/art/ice_cream/ice_cream_watermelon.png"),]

## Array of the different ice cream topping textures
const TOPPINGS = [
		preload("res://scenes/ice_cream_scene/art/toppings/topcacaop.png"), 
		preload("res://scenes/ice_cream_scene/art/toppings/topcoconut.png"), 
		preload("res://scenes/ice_cream_scene/art/toppings/topgold.png"), 
		preload("res://scenes/ice_cream_scene/art/toppings/toppinksugar.png"), 
		preload("res://scenes/ice_cream_scene/art/toppings/topsprinkles.png"), 
		preload("res://scenes/ice_cream_scene/art/toppings/topsyrupblue.png"),
		preload("res://scenes/ice_cream_scene/art/toppings/topsyrupcaramel.png"), 
		preload("res://scenes/ice_cream_scene/art/toppings/topsyrupchoco.png"), 
		preload("res://scenes/ice_cream_scene/art/toppings/topsyruplime.png"), 
		preload("res://scenes/ice_cream_scene/art/toppings/topsyrupstrawberry.png"),]


# Get the screen size
@onready var screen_size :Vector2 = get_viewport_rect().size
# Set the out of bounds y-marker
@onready var below_screen_y = screen_size.y + 200

var speed = 500 ## the speed at which the ice cream falls
var is_falling = true ## a boolean to determine if the ice cream is falling or not



## Randomly assign a texture and topping to the ice cream scoop
func _ready() -> void:
	$IceCreamSprite.texture = FLAVORS.pick_random()
	$ToppingSprite.texture = TOPPINGS.pick_random()
	speed = randi_range(400, 600)



## Make the ice cream fall, call queue_free() if it falls below the screen bounds
func _process(delta: float) -> void:
	if is_falling == true:
		position.y += speed * delta
	if (position.y > below_screen_y) and (is_falling == true):
		queue_free()

