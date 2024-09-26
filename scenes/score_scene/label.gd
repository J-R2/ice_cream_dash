extends Label

var player = null

func _ready() -> void:
	player = get_tree().get_nodes_in_group("player")
	player[0].scoops_added.connect(_on_scoops_added)

func _on_scoops_added(amount:int):
	text = str(amount)
