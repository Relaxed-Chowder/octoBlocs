extends Panel
var piece_class = load("res://scripts/piece_class.gd")

var color_list = Global.colors

var orginized : Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	orginize() 
	print("click", orginized.size())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func orginize():
	for i in range(Global.piece_full.size()):
		var color_number := 0
		var piece_number := 0
		var color = Global.piece_full[i].color
		var piece = Global.piece_full[i].type
		for j in range(Global.colors.size()):
			if color == Global.colors[j]:
				color_number = j
				break
		for j in range(Global.tetrominoes.size()):
			if piece == Global.tetrominoes[j]:
				color_number = j
				break
		
		if orginized.is_empty():
			orginized.append(Global.piece_full[i])
		
		
