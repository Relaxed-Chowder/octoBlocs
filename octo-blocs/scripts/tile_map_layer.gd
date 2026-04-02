extends TileMapLayer
var piece_class = load("res://scripts/piece_class.gd")

#tetrominoes
var i_0 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(3, 1)]
var i_90 := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2), Vector2i(1, 3)]
var i_180 := [Vector2i(0, 2), Vector2i(1, 2), Vector2i(2, 2), Vector2i(3, 2)]
var i_270 := [Vector2i(2, 0), Vector2i(2, 1), Vector2i(2, 2), Vector2i(2, 3)]
var i := [i_0, i_90, i_180, i_270]

var t_0 := [Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)]
var t_90 := [Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, 2)]
var t_180 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(1, 2)]
var t_270 := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(2, 1), Vector2i(1, 2)]
var t := [t_0, t_90, t_180, t_270]

var o_0 := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)]
var o := [o_0]

var z_0 := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(2, 1)]
var z_90 := [Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(0, 2)]
var z_180 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, 2), Vector2i(2, 2)]
var z_270 := [Vector2i(2, 0), Vector2i(1, 1), Vector2i(2, 1), Vector2i(1, 2)]
var z := [z_0, z_90, z_180, z_270]

var s_0 := [Vector2i(1, 0), Vector2i(2, 0), Vector2i(0, 1), Vector2i(1, 1)]
var s_90 := [Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, 2)]
var s_180 := [Vector2i(1, 1), Vector2i(2, 1), Vector2i(0, 2), Vector2i(1, 2)]
var s_270 := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(2, 1), Vector2i(2, 2)]
var s := [s_0, s_90, s_180, s_270]

var l_0 := [Vector2i(2, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)]
var l_90 := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2)]
var l_180 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(0, 2)]
var l_270 := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2), Vector2i(2, 2)]
var l := [l_0, l_90, l_180, l_270]

var j_0 := [Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)]
var j_90 := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(0, 2), Vector2i(1, 2)]
var j_180 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(2, 2)]
var j_270 := [Vector2i(1, 0), Vector2i(2, 0), Vector2i(1, 1), Vector2i(1, 2)]
var j := [j_0, j_90, j_180, j_270]

var tetrominoes := [i, t, o, z, s, l, j]

#colors
var r := Vector2i(1,0)
var g := Vector2i(2,0)
var b := Vector2i(3,0)

var colors := [r, g, b]

# speed
var steps : Array
const steps_req := 50
var speed : float
var speed_type := [1.0]

#grid variables
const COLS : int = 10
const ROWS : int = 18

# movement
const directions := [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.DOWN]
const start_pos := Vector2i(5,1)
var current_pos : Vector2i

#game piece variables
var count : int
var piece_deck : Array
var piece_type : Array
var next_piece_type
var rotation_index : int = 0
var active_piece : Array

#tilemap variables
var tile_id : int = 0
var piece_atlas : Vector2i
var next_piece_atlas : Vector2i

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()

func new_game():
	speed = 1.0
	steps = [0, 0, 0] #left, right, down
	deck(tetrominoes, colors, speed_type)
	var piece_full := piece_deck.duplicate()
	count = piece_deck.size()
	piece_deck.shuffle()
	piece_type = pick_piece()
	print(count)
	create_piece()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	if Input.is_action_pressed("ui_down"):
		steps[2] += 8
	elif Input.is_action_pressed("ui_right"):
		steps[1] += 8
	elif Input.is_action_pressed("ui_left"):
		steps[0] += 8
	
	steps[2] += speed
	
	for i in range(steps.size()):
		if steps[i] > steps_req:
			move_piece(directions[i])
			steps[i] = 0
	
func pick_piece():
	var piece : Array
	piece.resize(2)
	if not piece_deck.is_empty():
		piece[0] = piece_deck[0].type
		piece[1] = piece_deck[0].color
		print(piece_deck[0].type)
		piece_deck.pop_front()
	
	else:
		piece_deck.push_front(piece_class.new(o, g))
		piece = piece_deck.pop_front()
	return piece

func deck(tetrominoes, colors, speed_type):
	for i in range(colors.size()):
		for j in range(tetrominoes.size()):
			var game_piece = piece_class.new()
			game_piece.type = tetrominoes[j]
			game_piece.color = colors[i]
			game_piece.weight = speed_type[0]
			piece_deck.push_front(game_piece)

func create_piece():
	steps = [0, 0, 0] #left, right, down
	current_pos = start_pos
	active_piece = piece_type[rotation_index]
	draw_piece(piece_type[0], current_pos, piece_type[1])
	

func draw_piece(piece, pos, atlas):
	for i in piece[0]:
		set_cell(pos+i, tile_id, atlas)
		
func clear_piece():
	for i in active_piece[0]:
		erase_cell(current_pos + i)

func move_piece(dir):
	if can_move(dir):
		clear_piece()
		current_pos += dir
		draw_piece(piece_type[0], current_pos, piece_type[1])
	
func can_move(dir):
	var question = true
	for i in active_piece[0]:
		if not is_free(i + current_pos + dir):
			question = false
	return question
	
func is_free(pos):
	return get_cell_source_id(pos) == -1
	
