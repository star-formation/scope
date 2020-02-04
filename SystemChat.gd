extends Control


var player = "azariah"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _gui_input(ev):
	accept_event()
	if ev is InputEventKey:
		if ev.pressed and ev.scancode == KEY_ENTER:
			send_message()

func send_message():
	var msg = $SystemChat/ChatInput.text
	$SystemChat/ChatDisplay.text += player + ": " + msg + "\n"
	
