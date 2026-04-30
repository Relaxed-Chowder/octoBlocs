extends Button
@onready var DECK = $DECK

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	DECK.set_visible(Global.deck_visable)



func _on_pressed() -> void:
	Global.deck_visable = !Global.deck_visable
