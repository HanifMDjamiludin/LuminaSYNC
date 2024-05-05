'''
Tests the MQTT connection, and directly publishes a message to the MQTT broker, controlling the LED strip.
'''

import paho.mqtt.client as mqtt

# Define event callbacks
def on_connect(client, userdata, flags, rc):
    print(f"Connected with result code {rc}")
    client.subscribe("test/topic")

def on_message(client, userdata, msg):
    print(f"Topic: {msg.topic} Message: {msg.payload}")

def on_publish(client, userdata, mid):
    print(f"Mid: {mid} published.")

def on_subscribe(client, userdata, mid, granted_qos):
    print("Subscribed: " + str(mid) + " " + str(granted_qos))

def on_log(client, userdata, level, buf):
    print(f"Log: {buf}")

# Setup
client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION1)
client.on_connect = on_connect
client.on_message = on_message
client.on_publish = on_publish
client.on_subscribe = on_subscribe
client.on_log = on_log

# Connect
client.connect("34.145.206.196", 1883, 60) 

# Start loop
client.loop_start()

# Publish message (Test Code, APP implementation is through backend)
# client.publish("4291ca36-c9c3-5fd7-abb8-d74469c7a2f7/color", """FFFFFF""")
# client.publish("4291ca36-c9c3-5fd7-abb8-d74469c7a2f7/power", "off")
# client.publish("4291ca36-c9c3-5fd7-abb8-d74469c7a2f7/brightness", "100")
# client.publish("4291ca36-c9c3-5fd7-abb8-d74469c7a2f7/effect", "Rainbow swirl")
# client.publish("4291ca36-c9c3-5fd7-abb8-d74469c7a2f7/pattern", """{"interval": 500, "iconColor": "ff2196f3", "position1": ["ffffffff", "ff000000"], "position2": ["ff000000", "ffffffff"], "patternType": "User"}""")
# client.publish("4291ca36-c9c3-5fd7-abb8-d74469c7a2f7/pattern/stop", """""")
# Stop loop after some time
client.loop_stop()
