extends StaticBody2D

var tiletexture
var tilename
var realtexture

func _ready():
	$Sprite2D.texture = self.tiletexture
