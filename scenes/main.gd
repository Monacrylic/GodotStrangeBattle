extends Node

var receivedmessagecount = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	
	var brokerurl = "10.56.6.114"
	var protocol = "tcp://"
	$MQTT.connect_to_broker("%s%s:%s" % [protocol, brokerurl, 1883])
	print("Below are Important details")
	print(protocol)
	print(brokerurl)
	
	
	
func _on_mqtt_broker_connected():
	print("Connected")
	var qos = 0
	
	$MQTT.subscribe("IDD/player1/pulse/start", qos)
	$MQTT.subscribe("IDD/player2/pulse/start", qos)
	$MQTT.subscribe("IDD/player1/shield/start", qos)
	$MQTT.subscribe("IDD/player2/shield/start", qos)
	$MQTT.subscribe("IDD/player1/shield/end", qos)
	$MQTT.subscribe("IDD/player2/shield/end", qos)
	
	receivedmessagecount = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mqtt_received_message(topic, message):
	receivedmessagecount += 1
	print(topic)
	print(message)
	match topic:
		"IDD/player1/pulse/start":
			$Player1.player1_attack()
		"IDD/player2/pulse/start":
			$Player2.player2_attack()
		"IDD/player1/shield/start":
			$Player1.player1_defend(true)
		"IDD/player1/shield/end":
			$Player1.player1_defend(false)
		"IDD/player2/shield/start":
			$Player2.player2_defend(true)
		"IDD/player2/shield/end":
			$Player2.player2_defend(false)
		
func mqtt_injurePlayer(playerID, playerDamage):
	$MQTT.publish("IDD/player" + str(playerID) + "/damage", str(playerDamage), false)
	
func mqtt_successfulDefend(playerID):
	$MQTT.publish("IDD/player" + str(playerID) + "/successfulDefend", str(0), false)
	
	
