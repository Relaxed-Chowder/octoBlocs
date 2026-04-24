extends Panel
@onready var tile_map_layer = get_node("res://scripts/tile_map_layer.gd")

var deck = tile_map_layer.piece_deck
var full = deck[0]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	orginize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $DECK.visible == true:
		pass

func open():
	var deck = tile_map_layer.piece_deck
	var full = deck[0]

func orginize():
	for i in range(full.size()):
		deck[0][i][1]
		
