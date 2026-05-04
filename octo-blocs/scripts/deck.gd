extends Panel
var piece_class = load("res://scripts/piece_class.gd")
@onready var piece_dispaly = $piece_display
@onready var DECK = $".."
var tile_id : int = 0
var y = 0
var orginized : Array
var pages = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	orginize() 
	for i in range(orginized.size()-1):
		print("click ", orginized[y].color)
		y += 1
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if DECK.is_visible():
		create_piece()


func orginize():
	orginized = Global.piece_full
	for i in range(orginized.size()):
		var j = i
		var c1 = Global.colors.find(orginized[j].color)
		var p1 = Global.tetrominoes.find(orginized[j].type)
		var c2 = Global.colors.find(orginized[j-1].color)
		var p2 = Global.tetrominoes.find(orginized[j-1].type)
		while j > 0 and c2>c1:
			c1 = Global.colors.find(orginized[j].color)
			c2 = Global.colors.find(orginized[j-1].color)
			var temp = orginized[j-1]
			orginized[j-1] = orginized[j]
			orginized[j] = temp
			j = j-1
		while j > 0 and p2>p1:
			p1 = Global.tetrominoes.find(orginized[j].type)
			p2 = Global.tetrominoes.find(orginized[j-1].type)
			var temp = orginized[j-1]
			orginized[j-1] = orginized[j]
			orginized[j] = temp
			j = j-1
			
func create_piece():
	var i = pages * 35
	for j in range(7):
		for z in range(5):
			if orginized.size() > i:
				draw_piece(orginized[i].type[0], Vector2i(7+(5*j),2+(5*z)), orginized[i].color)
			i += 1
		
func draw_piece(piece, pos, atlas):
	for i in piece:
		piece_dispaly.set_cell(pos+i, tile_id, atlas)
		
func clear_piece():
	for n in range(48):
		for z in range(25):
			piece_dispaly.erase_cell(Vector2i(n, z))
		
func _on_left_pressed() -> void:
	if pages > 0:
		print ("click")
		pages -= 1
		clear_piece()
		create_piece()

func _on_right_pressed() -> void:
	if pages < floor(float(orginized.size())/35):
		print ("click")
		pages += 1
		clear_piece()
		create_piece()
