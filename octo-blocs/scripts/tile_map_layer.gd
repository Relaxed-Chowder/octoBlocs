extends TileMapLayer
var piece_class = load("res://scripts/piece_class.gd")
@onready var board_layer : TileMapLayer = $/root/game/board
@onready var node = $/root/game/active
@onready var score_sound = $scoreSound
@onready var connect = $connect
@onready var noMove = $noMove
@onready var tile_map_layer = "res://scripts/deck.gd"

#tetrominoes
var i_0 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(3, 1)]
var i_90 := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2), Vector2i(1, 3)]
var i_180 := [Vector2i(0, 2), Vector2i(1, 2), Vector2i(2, 2), Vector2i(3, 2)]
var i_270 := [Vector2i(2, 0), Vector2i(2, 1), Vector2i(2, 2), Vector2i(2, 3)]
var I := [i_0, i_90, i_180, i_270]

var t_0 := [Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)]
var t_90 := [Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, 2)]
var t_180 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(1, 2)]
var t_270 := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(2, 1), Vector2i(1, 2)]
var t := [t_0, t_90, t_180, t_270]

var o_0 := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)]
var o_1 := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)]
var o_2 := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)]
var o_3 := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)]
var o := [o_0, o_1, o_2, o_3]

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
var J := [j_0, j_90, j_180, j_270]

var tetrominoes := [I, t, o, z, s, l, J]

#colors
var r := Vector2i(1,0)
var g := Vector2i(2,0)
var b := Vector2i(3,0)
var k := Vector2i(1,2)

var colors := [r, g, b]

#speed
const directions := [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.DOWN]
var steps : Array
const steps_req := 50
var speed : float
var speed_type := [1.0]
var accelerate := 0.25

#grid variables
const COLS : int = 10
const ROWS : int = 18

#score
var score : float
var points : int = 0
var point_reward : Array = [
	[40, 100, 300, 1200], 
	[80, 200, 600, 2400], 
	[null, 300, 900, 3600], 
	[null, null, 1200, 4800], 
	[null, null, null, 6000]
]

#movement
var rotate_cooldown := 0.5
const start_pos := Vector2i(5,1)
var current_pos : Vector2i

#game piece variables
var count : int
var piece_deck : Array
var piece_full : Array
var piece_type : Array
var next_piece_type
var rotation_index : int = 0
var active_piece : Array
var game_end_count : int = 0
var game_over := false

#tilemap variables
var tile_id : int = 0
var piece_atlas : Vector2i
var next_piece_atlas : Vector2i

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()

func new_game():
	get_node("/root/game/HUD/GameOverLabel").hide()
	speed = 1.0
	steps = [0,0,0] #0: left, 1: right, 2: down
	deck(tetrominoes, colors, speed_type)
	print(piece_deck.size())
	piece_full = piece_deck.duplicate()
	count = piece_deck.size()
	piece_deck.shuffle()
	piece_type = pick_piece()
	
	next_piece_type = pick_piece()
	print(piece_deck)
	create_piece()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	if Input.is_physical_key_pressed(KEY_R) and rotate_cooldown:
		rotate_cooldown = false
		$rotateTimer.start()
		rotate_piece()
		
	if Input.is_action_pressed("ui_down"):
		steps[2] += 8
	if Input.is_action_pressed("ui_left"):
		steps[0] += 8
	if Input.is_action_pressed("ui_right"):
		steps[1] += 8
		
	steps[2] += speed
	
	for i in range(steps.size()):
		if steps[i] > steps_req:
			steps[i] = 0
			move_piece(directions[i])
	
func pick_piece():
	var piece : Array
	piece.resize(2)
	if not piece_deck.is_empty():
		piece[0] = piece_deck[0].type
		piece[1] = piece_deck[0].color
		print(piece_deck[0].type)
		piece_deck.pop_front()
	
	else:
		game_end_count += 1
		if(game_end_count > 1):
			get_node("/root/game/HUD/GameOverLabel").show()
			game_over = true
		piece[0] = I
		piece[1] = k
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
	steps = [0,0,0] #0: left, 1: right, 2: down
	current_pos = start_pos
	active_piece = piece_type[0][rotation_index]
	draw_piece(active_piece, current_pos, piece_type[1])
	
	#next piece
	draw_piece(next_piece_type[0][0], Vector2i(18,6), next_piece_type[1])
	
func draw_piece(piece, pos, atlas):
	for i in piece:
		set_cell(pos+i, tile_id, atlas)
		
func clear_piece():
	for i in active_piece:
		erase_cell(current_pos + i)

func rotate_piece():
	if can_rotate():
		clear_piece()
		rotation_index = (rotation_index + 1) % 4
		active_piece = piece_type[0][rotation_index]
		draw_piece(active_piece, current_pos, piece_type[1])
	
func can_rotate():
	var canRotate = true
	var temp_rotation_index : int = (rotation_index + 1) % piece_type[0].size()
	for i in piece_type[0][temp_rotation_index]:
		if not is_free(i+current_pos):
			canRotate = false
			noMove.play()
			
	return canRotate

func move_piece(dir):
	if can_move(dir):
		clear_piece()
		current_pos += dir
		draw_piece(active_piece, current_pos, piece_type[1])
		
	else:
		if dir == Vector2i.DOWN:
			ground_piece()
			check_rows()
			piece_type[0] = next_piece_type[0]
			piece_type[1] = next_piece_type[1]
			next_piece_type = pick_piece()
			create_piece()
			steps = [0,0,0]
			
	
func can_move(dir):
	var canMove = true
	for i in active_piece:
		if not is_free(i+current_pos+dir):
			canMove = false
	return canMove

func is_free(pos):
	return board_layer.get_cell_tile_data(pos) == null

func _on_timer_timeout() -> void:
	rotate_cooldown = true
	
func ground_piece():
	print("active_piece ", active_piece)
	for i in active_piece:
		erase_cell(current_pos + i)
		board_layer.set_cell(current_pos+i, tile_id, piece_type[1])
	clear_next()
	connect.play()
		
func clear_next():
	for i in range(14,24):
		for j in range(3,10):
			erase_cell(Vector2i(i,j))
			
func check_rows():
	var row : int = ROWS
	var lc := 0
	var scc := 0
	var color_storing : Array
	while row > 0:
		var count = 0
		var color_count = 0
		for i in range(COLS):
			if not is_free(Vector2i(i + 1, row)):
				count += 1
				if board_layer.get_cell_atlas_coords(Vector2i((i + 1)%COLS, row)) == board_layer.get_cell_atlas_coords(Vector2i(i + 2, row)):
					color_count += 1
			else:
				row -= 1
		
		# same color
		if count == COLS and color_count == COLS:
			scc += 1
			shift_rows(row)
			
		# lines
		elif count == COLS:
			lc += 1
			shift_rows(row)
		
	if (lc > 0 or scc > 0) and !game_over:
		var tempscc = scc
		if scc != 0:
			tempscc= tempscc-1
		score += point_reward[tempscc][lc-1]*floor(speed)
		get_node("/root/game/HUD/ScoreLabel").text = "SCORE: " + str(int(score))
		speed += accelerate
		print("line: ", lc, " color: ", scc)
		score_sound.play()
				
func shift_rows(row):
	var atlas
	for i in range(row, 1, -1):
		for j in range(COLS):
			atlas = board_layer.get_cell_atlas_coords(Vector2i(j+1, i-1))
			if atlas == Vector2i(-1, -1):
				board_layer.erase_cell(Vector2i(j+1, i))
			else:
				board_layer.set_cell(Vector2i(j+1, i), tile_id, atlas)
		
