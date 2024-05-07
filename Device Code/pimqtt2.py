import threading
import subprocess
import json
import paho.mqtt.client as mqtt
import time

# Global state dictionary to hold the last known good state
last_state = {}
# Global variable to hold the current power state
device_power = True
# Pattern running flag
pattern_active = False
# Pattern thread
pattern_thread = None

def get_hyperion_id():
    """ Function to get the Hyperion device ID. """
    try:
        # Run the hyperion-remote command and capture output
        result = subprocess.run(['hyperion-remote', '-s'], stdout=subprocess.PIPE, text=True)
        output = result.stdout

        # Find the start of the JSON data
        json_start = output.find('{')
        if json_start != -1:
            # Extract and parse the JSON data
            json_data = output[json_start:]
            data = json.loads(json_data)
            
            # Extract the device ID
            device_id = data['hyperion']['id']
            return device_id
    except Exception as e:
        print(f"Error obtaining device ID: {e}")
    return None

def apply_hyperion_command(topic, value):
    global device_power, pattern_active, pattern_thread
    try:
        if 'color' in topic:
            if not device_power:
                return # Ignore color commands if the power state is off
            if pattern_thread and pattern_thread.is_alive(): # Check if a pattern is running
                pattern_active = False # Set the pattern_active flag to False
                pattern_thread.join() # Wait for the pattern thread to finish
            subprocess.run(['hyperion-remote', '-c', value], check=True)
            last_state['color'] = value # Store the last color value

        elif 'effect' in topic:
            if not device_power:
                return # Ignore effect commands if the power state is off
            if pattern_thread and pattern_thread.is_alive(): # Check if a pattern is running
                pattern_active = False # Set the pattern_active flag to False
                pattern_thread.join() # Wait for the pattern thread to finish
            subprocess.run(['hyperion-remote', '-e', value], check=True)

        elif 'brightness' in topic:
            subprocess.run(['hyperion-remote', '-L', str(value)], check=True)

        elif 'power' in topic:
            if value.lower() == "on":
                device_power = True # Set power state to on
                restore_state() # Restore the last known good state
            elif value.lower() == "off":
                pattern_active = False # Stop the pattern
                device_power = False # Set power state to off
                subprocess.run(['hyperion-remote', '-c', '000000'], check=True)

        elif 'pattern/stop' in topic:
            if pattern_thread and pattern_thread.is_alive(): # Check if a pattern is running
                pattern_active = False # Set the pattern_active flag to False
                pattern_thread.join() # Wait for the pattern thread to finish
                restore_state() # Restore the last known good state

        elif 'pattern' in topic:
            if not device_power:
                return
            if pattern_thread and pattern_thread.is_alive():
                pattern_active = False
                pattern_thread.join()  # Wait for the current pattern to stop
            pattern_active = True
            pattern_thread = threading.Thread(target=run_pattern, args=(value,))
            pattern_thread.start()

        else:
            print(f"Received command on unknown topic: {topic}")
    except subprocess.CalledProcessError as e:
        print(f"Error executing command for topic '{topic}': {e}")

def run_pattern(value):
    '''Function to run a custom lighting pattern'''
    print(f"Running pattern: {value}")
    global pattern_active
    interval = value['interval'] / 1000
    position1 = ''.join(x[2:].upper() for x in value['position1'])
    position2 = ''.join(x[2:].upper() for x in value['position2'])

    while pattern_active:
        subprocess.run(['hyperion-remote', '-c', position1], check=True)
        time.sleep(interval)
        if not pattern_active:
            break  # Break if pattern_active becomes False
        subprocess.run(['hyperion-remote', '-c', position2], check=True)
        time.sleep(interval)
        if not pattern_active:
            break  # Break if pattern_active becomes False


def restore_state():
    '''Function to restore the last known good state'''
    if last_state.get('power', 'on') == 'on' and 'color' in last_state:
        subprocess.run(['hyperion-remote', '-c', last_state['color']], check=True)


# MQTT Callback Functions:

def on_message(client, userdata, msg):
    try:
        value = json.loads(msg.payload.decode())
    except json.JSONDecodeError:
        value = msg.payload.decode()

    print(f"Received message on topic '{msg.topic}': {value}")
    apply_hyperion_command(msg.topic, value)

def subscribe_to_topics(device_id):
    client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION1)
    client.on_connect = lambda client, userdata, flags, rc: [
        client.subscribe(f"{device_id}/{topic}") for topic in ['color', 'effect', 'brightness', 'power', 'pattern', 'pattern/stop']
    ]
    client.on_message = on_message
    client.connect("34.145.206.196", 1883, 60)
    client.loop_forever()

if __name__ == "__main__":
    device_id = get_hyperion_id()
    if device_id:
        subscribe_to_topics(device_id)
