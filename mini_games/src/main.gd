extends Area2D

var tile = preload("res://mini_games/tile.tscn")
var tiles = []
var solved = []
var mouse = false
var tile_h = 0
var offset = 0
var t
var movecounter = 0
var previous = ""

@onready var sprite_2d = $CanvasLayer/Sprite2D
@onready var move_counter = $CanvasLayer/move_counter
@onready var full_image = $FullImage

func _ready():
	start_game()
	update_text()
func start_game():
	$CanvasLayer/Button.hide()
	$FullImage.hide()
	var screen_width = 1152 
	var screen_height = 648
	@warning_ignore("integer_division")
	sprite_2d.position.x = (screen_width/4) * 3.15
	sprite_2d.position.y = screen_height/4
	move_counter.position.x = (screen_width/4) * 2.825
	move_counter.position.y = screen_height/4 + 200
	full_image.position.x = 1024/2+27
	full_image.position.y = 1024/2+27
	
	tile_h = 1024/4
	offset = tile_h + 2    
	var image = Image.load_from_file("res://mini_games/img/puzzle1.png")
	var texture = ImageTexture.create_from_image(image)
	var greyimage = Image.load_from_file("res://mini_games/img/greytile.png")
	var greytexture = ImageTexture.create_from_image(greyimage)
	$FullImage.texture = texture

	for j in range(0,4):
		for i in range(0,4):
			var myregion = Rect2i(i * tile_h,j * tile_h,tile_h,tile_h)
			var newimage = image.get_region(myregion)
			var newtexture = ImageTexture.create_from_image(newimage)
			var newtile = tile.instantiate()
			newtile.position.x = tile_h * i + tile_h/2 + i*2 + 25
			newtile.position.y = tile_h * j + tile_h/2 + j*2 + 25
			newtile.tilename = "Tile" + str(j * 4 + i + 1)
			
			var label = Label.new()
			label.text = str(j * 4 + i + 1)
			newtile.add_child(label) 
			
			if newtile.tilename == "Tile16":
				newtile.tiletexture = greytexture
				newtile.realtexture = newtexture
			else:
				newtile.tiletexture = newtexture
			#add_child(newtile)
			get_tree().get_first_node_in_group("Tileholder").add_child(newtile)
			tiles.append(newtile)

	solved = tiles.duplicate()
	shuffle_tiles()
	movecounter = 0

func shuffle_tiles():
	offset = tile_h + 2
	t = 0
	while t < 50:
		var atile = randi() % 16
		if tiles[atile].tilename != "Tile16" and tiles[atile].tilename != previous:
			var rows = int(tiles[atile].position.y / offset)
			var cols = int(tiles[atile].position.x / offset)
			check_neighbours(rows,cols)

func update_text():
	var move_counter_node = get_node("CanvasLayer/move_counter")
	if move_counter_node:
		move_counter_node.text = "Move Counter: %d" % movecounter
	else:
		print("Error: move_counter node not found!")

func _process(_delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and mouse:
		var mouse_copy = mouse
		mouse = false
		var rows = int(mouse_copy.position.y / offset)
		var cols = int(mouse_copy.position.x / offset)
		check_neighbours(rows,cols)
		if tiles == solved and movecounter > 1:
			print("You win in ", str(movecounter, " moves!!"))
			$FullImage.show()
			$CanvasLayer/TileHolder.hide()
			$CanvasLayer/Button.show()

func check_neighbours(rows, cols):
	var empty = false
	var done = false
	var pos = rows * 4 + cols
	while !empty and !done:
		var new_pos = tiles[pos].position
		if rows < 3:
			new_pos.y += offset
			empty = find_empty(new_pos,pos)
			new_pos.y -= offset
		if rows > 0:
			new_pos.y -= offset
			empty = find_empty(new_pos,pos)
			new_pos.y += offset
		if cols < 3:
			new_pos.x += offset
			empty = find_empty(new_pos,pos)
			new_pos.x -= offset
		if cols > 0:
			new_pos.x -= offset
			empty = find_empty(new_pos,pos)
			new_pos.x += offset
		done = true

func find_empty(_position,_pos):
	var new_rows = int(_position.y / offset)
	var new_cols = int(_position.x / offset)
	var new_pos = new_rows * 4 + new_cols
	if tiles[new_pos].tilename == "Tile16" and tiles[new_pos].tilename != previous:
		swap_tiles(_pos, new_pos)
		t += 1
		return true
	else:
		return false

func swap_tiles(tile_src, tile_dst):
	var temp_pos = tiles[tile_src].position
	tiles[tile_src].position = tiles[tile_dst].position
	tiles[tile_dst].position = temp_pos
	
	var temp_tile = tiles[tile_src]
	tiles[tile_src] = tiles[tile_dst]
	tiles[tile_dst] = temp_tile
	
	movecounter += 1
	update_text()

	previous = tiles[tile_dst].tilename


func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		mouse = event

func _on_button_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")
