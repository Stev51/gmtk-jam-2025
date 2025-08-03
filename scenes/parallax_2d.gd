extends Parallax2D

# randomizes star movement
func _ready():
	var speed = randfn(12, 2)
	var angle = randf() * PI * 2
	self.autoscroll = Vector2(speed * cos(angle), speed * sin(angle))
