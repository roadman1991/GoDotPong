extends Node2D

#Member variables
var screen_size
var pad_size
var direction = Vector2(1.0, 0.0)

#Constant for ball speed (in pixels/second)
const INITIAL_BALL_SPEED = 125
#Speed of the ball (pixels/second)
var ball_speed = INITIAL_BALL_SPEED
#Constant for pads speed
const PAD_SPEED = 150

func _ready():
	screen_size = get_viewport_rect().size
	pad_size = get_node("left").get_texture().get_size()
	set_process(true)
	pass
	
func _process(delta):
	var ball_pos = get_node("ball").position
	var left_rect = Rect2(get_node("left").position - pad_size * 0.5, pad_size)
	var right_rect = Rect2(get_node("right").position - pad_size * 0.5, pad_size)
	
	#Integrate new ball position
	ball_pos += direction * ball_speed * delta
	get_node("ball").position = ball_pos
	
	#flip when toughing roof or floor
	if((ball_pos.y < 0 and direction.y < 0) or (ball_pos.y > screen_size.y and direction.y > 0)):
		direction.y = -direction.y
		
	#Flip, change direction and increase speed when touching pads
	if ((left_rect.has_point(ball_pos) and direction.x < 0) or (right_rect.has_point(ball_pos) and direction.x > 0)):
		direction.x = -direction.x
		direction.y = randf() * 2.0 - 1
		direction = direction.normalized()
		ball_speed *= 1.1
		
	#Check gameover
	if(ball_pos.x < 0):
		ball_pos = screen_size * 0.5
		get_node("ball").position = ball_pos
		ball_speed = INITIAL_BALL_SPEED
		direction = Vector2(-1, 0)
		var scoreright = get_node("scoreRight").text.to_int()
		scoreright += 1
		get_node("scoreRight").set_text(str(scoreright))
	if(ball_pos.x > screen_size.x):
		ball_pos = screen_size * 0.5
		get_node("ball").position = ball_pos
		ball_speed = INITIAL_BALL_SPEED
		direction = Vector2(-1, 0)
		var scoreleft = get_node("scoreLeft").text.to_int()
		scoreleft += 1
		get_node("scoreLeft").set_text(str(scoreleft))
		
	# Move left pad
	if(get_node("left").position.y > 0 and Input.is_action_pressed("left_move_up")):
		get_node("left").position.y += -PAD_SPEED * delta
	if(get_node("left").position.y < screen_size.y and Input.is_action_pressed("left_move_down")):
		get_node("left").position.y += PAD_SPEED * delta
		
	# Move right pad
	if(get_node("right").position.y > 0 and Input.is_action_pressed("right_move_up")):
		get_node("right").position.y += -PAD_SPEED * delta
	if(get_node("right").position.y < screen_size.y and Input.is_action_pressed("right_move_down")):
		get_node("right").position.y += PAD_SPEED * delta