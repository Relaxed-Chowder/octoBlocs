extends Panel
var piece_class = load("res://scripts/piece_class.gd")
@onready var piece_dispaly = $piece_display
var tile_id : int = 0

var orginized : Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("click", Global.piece_full.size())
	orginize() 
	print("click", orginized.size())
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	create_piece()


func orginize():
	orginized = Global.piece_full
	for i in range(1, orginized.size()):
		var icount = i
		print("icount", icount)
		var c1 = Global.colors.find(orginized[icount].color)
		var p1 = Global.tetrominoes.find(orginized[icount].type)
		var c2 = Global.colors.find(orginized[icount-1].color)
		var p2 = Global.tetrominoes.find(orginized[icount-1].type)
		while icount > 0 and c1 > c2:
			var temp = orginized[icount-1]
			orginized[icount-1] = orginized[icount]
			orginized[icount] = temp
			icount -= 1
			
		while icount > 0 and p1 > p2:
			var temp = orginized[icount-1]
			orginized[icount-1] = orginized[icount]
			orginized[icount] = temp
			icount -= 1
			
func create_piece():
	for i in range(orginized.size()):
		draw_piece(orginized[i].type[0], Vector2i((0+(6*i))%48,(0+(8*i))%26), orginized[i].color)
		
func draw_piece(piece, pos, atlas):
	for i in piece:
		piece_dispaly.set_cell(pos+i, tile_id, atlas)
