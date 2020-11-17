extends Node

# https://docs.godotengine.org/en/stable/tutorials/networking/websocket.html

# The URL we will connect to
export var websocket_url = "ws://127.0.0.1:8081"
export var websocket_subprotocol = "client0.argonavis.io"

# Our WebSocketClient instance
var _client = null

func _ready():
	_client = WebSocketClient.new()
	_client.set_verify_ssl_enabled(false)
	# Connect base signals to get notified of connection open, close, and errors.
	_client.connect("connection_closed", self, "_ws_closed")
	_client.connect("connection_error", self, "_ws_error")
	_client.connect("connection_established", self, "_ws_connected")
	# This signal is emitted when not using the Multiplayer API every time
	# a full packet is received.
	# Alternatively, you could check get_peer(1).get_available_packets() in a loop.
	var connErr = _client.connect("data_received", self, "_ws_on_data")
	print("WebSocket: connErr: ", connErr)

	# Initiate connection to the given URL.
	var sps = PoolStringArray()
	sps.append(websocket_subprotocol)
	var err = _client.connect_to_url(websocket_url, sps)
	if err != OK:
		print("WebSocket: unable to connect")
		set_process(false)

func _ws_closed(was_clean = false):
	# was_clean will tell you if the disconnection was correctly notified
	# by the remote peer before closing the socket.
	print("WebSocket: closed, clean: ", was_clean)
	set_process(false)

func _ws_error(was_clean = false):
	print("WebSocket: closed, clean: ", was_clean)
	set_process(false)

func _ws_connected(proto = ""):
	# This is called on connection, "proto" will be the selected WebSocket
	# sub-protocol (which is optional)
	print("WebSocket: connected: url: protocol: ", websocket_url)
	print("WebSocket: connected: protocol: ", proto)
	# You MUST always use get_peer(1).put_packet to send data to server,
	# and not put_packet directly when not using the MultiplayerAPI.
	_client.get_peer(1).put_packet("Test packet".to_utf8())

func _ws_on_data():
	# Print the received packet, you MUST always use get_peer(1).get_packet
	# to receive data from server, and not get_packet directly when not
	# using the MultiplayerAPI.
	var data = _client.get_peer(1).get_packet().get_string_from_utf8()
	print("WebSocket: on data: msg len: ", data.length())
	#print("WebSocket: data from server: ", data)
	var j = JSON.parse(data)
	if j.error != OK:
		print("WebSocket: error parsing JSON from server: ", j.error, j.error_string)
		return
		
	var points = j.result["OrbitalPoints"]
	#print("points: ", points)
	var v3s = PoolVector3Array()
	for p in points:
		var v = Vector3()
		v.x = p["X"]
		v.y = p["Z"]
		v.z = p["Y"]
		v3s.append(v)
	get_node("Orbit").draw_points(v3s)
	
func _process(_delta):
	# Call this in _process or _physics_process. Data transfer, and signals
	# emission will only happen when calling this function.
	_client.poll()
