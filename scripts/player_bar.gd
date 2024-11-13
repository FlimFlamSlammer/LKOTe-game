extends TextureProgressBar

@export var signal_name: String

@onready var player: Player = get_node(WorldScene.player_path)

func _ready() -> void:
	if (not player.is_node_ready()):
		await player.ready
	player.connect(signal_name, _update_bar)


func _update_bar(_value: float, value_ratio: float) -> void:
	ratio = value_ratio
