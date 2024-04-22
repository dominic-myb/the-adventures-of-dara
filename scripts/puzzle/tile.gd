extends TextureButton

var number
signal tile_pressed
signal slide_completed

func set_text(new_number):
	number = new_number
	$Sprite2D/Number/Label.text = str(number)

func set_sprite(new_frame, _size, tile_size):
	var sprite = $Sprite2D
	update_size(_size, tile_size)
	sprite.set_hframes(_size)
	sprite.set_vframes(_size)
	sprite.set_frame(new_frame)

func update_size(_size, tile_size):
	var new_size = Vector2(tile_size, tile_size)
	set_size(new_size)
	$Sprite2D/Number.set_size(new_size)
	$Sprite2D/Number/ColorRect.set_size(new_size)
	$Sprite2D/Number/Label.set_size(new_size)
	$Border.set_size(new_size)
	
	var to_scale = _size * (new_size / $Sprite2D.texture.get_size())
	$Sprite2D.set_scale(to_scale)

func set_sprite_texture(texture):
	$Sprite2D.set_texture(texture)

func slide_to(new_position, duration):
	var tween : Tween = Tween.new()
	tween.interpolate_property(
		self, "rect_position", 
		null, new_position, duration, 
		Tween.TRANS_QUART, Tween.EASE_OUT
	)
	tween.connect("slide_completed", _on_tween_completed)
	tween.start()
	
func set_number_visible(state):
	$Sprite2D/Number.visible = state
	
func _on_tile_pressed():
	emit_signal("tile_pressed", number)
	
func _on_tween_completed(_object, _key):
	emit_signal("slide_completed", number)
