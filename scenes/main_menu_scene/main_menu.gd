extends Control


@onready var play_button: TextureButton = $TextureRect/ButtonVBoxContainer/PlayButton
@onready var quit_button: TextureButton = $TextureRect/ButtonVBoxContainer/QuitButton
@onready var rules_v_box_container: VBoxContainer = $TextureRect/RulesVBoxContainer
@onready var button_v_box_container: VBoxContainer = $TextureRect/ButtonVBoxContainer
@onready var game_over_v_box_container: VBoxContainer = $TextureRect/GameOverVBoxContainer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


const GAME_OVER_SOUND := preload("res://sfx/vgdeathsound.ogg")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_button.mouse_entered.connect(audio_stream_player.play)
	quit_button.mouse_entered.connect(audio_stream_player.play)
	play_button.focus_entered.connect(audio_stream_player.play)
	quit_button.focus_entered.connect(audio_stream_player.play)
	play_button.pressed.connect(_on_play_button_pressed)
	quit_button.pressed.connect(get_tree().quit)
	# only show the buttons
	button_v_box_container.show()
	rules_v_box_container.hide()
	game_over_v_box_container.hide()
	# hide the player
	get_tree().get_first_node_in_group("player").hide()
	# connect to the game over signal
	get_tree().get_first_node_in_group("player").game_over.connect(_on_game_over)
	# don't pause this scene
	process_mode = Node.PROCESS_MODE_ALWAYS
	# pause the rest of the game
	get_tree().paused = true



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
	# disable the buttons
	play_button.disabled = true
	quit_button.disabled = true
	# hide the buttons then show the rules
	game_over_v_box_container.hide()
	button_v_box_container.hide()
	rules_v_box_container.show()
	# only show the rules for 5 seconds
	var timer = Timer.new()
	self.add_child(timer)
	timer.wait_time = 5.0
	timer.start()
	# unpause the game and hide the menu
	timer.timeout.connect(func() -> void :
		get_tree().paused = false
		hide()
		get_tree().get_first_node_in_group("player").show()
		timer.queue_free()
	)


