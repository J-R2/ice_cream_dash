extends Control


@onready var play_button: TextureButton = $TextureRect/ButtonVBoxContainer/PlayButton
@onready var quit_button: TextureButton = $TextureRect/ButtonVBoxContainer/QuitButton
@onready var rules_v_box_container: VBoxContainer = $TextureRect/RulesVBoxContainer
@onready var button_v_box_container: VBoxContainer = $TextureRect/ButtonVBoxContainer
@onready var game_over_v_box_container: VBoxContainer = $TextureRect/GameOverVBoxContainer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var rules_button: TextureButton = $TextureRect/ButtonVBoxContainer/RulesButton
@onready var return_button: TextureButton = $TextureRect/RulesVBoxContainer/ReturnButton

const GAME_OVER_SOUND := preload("res://sfx/vgdeathsound.ogg")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for button in [play_button, quit_button, rules_button, return_button]:
		button.mouse_entered.connect(audio_stream_player.play)
		button.focus_entered.connect(audio_stream_player.play)
	play_button.pressed.connect(_on_play_button_pressed)
	rules_button.pressed.connect(_on_rules_button_pressed)
	return_button.pressed.connect(show_main_menu)
	quit_button.pressed.connect(get_tree().quit)
	show_main_menu()

	# connect to the game over signal
	get_tree().get_first_node_in_group("player").game_over.connect(_on_game_over)
	# don't pause this scene
	process_mode = Node.PROCESS_MODE_ALWAYS
	# pause the rest of the game
	get_tree().paused = true


func _on_rules_button_pressed() -> void :
	hide_menu_entries()
	rules_v_box_container.show()
	return_button.disabled = false


func show_main_menu() -> void:
	hide_menu_entries()
	play_button.disabled = false
	rules_button.disabled = false
	quit_button.disabled = false
	button_v_box_container.show()



func _on_game_over() -> void :
	# pause the game
	get_tree().paused = true
	# only show the game over sign
	rules_v_box_container.hide()
	button_v_box_container.hide()
	game_over_v_box_container.show()
	self.show()
	audio_stream_player.stream = GAME_OVER_SOUND
	audio_stream_player.play()
	audio_stream_player.finished.connect(func() -> void:
		get_tree().reload_current_scene()
	)
	

func _on_play_button_pressed() -> void:
	disable_buttons()
	hide()
	get_tree().paused = false


func hide_menu_entries() -> void :
	disable_buttons()
	button_v_box_container.hide()
	rules_v_box_container.hide()
	game_over_v_box_container.hide()

func disable_buttons() -> void :
	for button in [rules_button, play_button, quit_button, return_button]:
		button.disabled = true
