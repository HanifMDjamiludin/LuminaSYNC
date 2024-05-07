import requests

# Base URL of the API
BASE_URL = "http://34.145.206.196:3000"

def test_health_check():
    response = requests.get(f"{BASE_URL}/health")
    assert response.status_code == 200
    assert response.text == "API is up and running!"
    # print("Health check passed")
    print(response.text)
    
def test_get_all_users():
    response = requests.get(f"{BASE_URL}/users")
    assert response.status_code == 200
    print(response.json())
    print("Get all users passed")

def test_get_specific_user(user_id):
    response = requests.get(f"{BASE_URL}/users/{user_id}")
    if response.status_code == 404:
        print(f"User with ID {user_id} not found")
    else:
        assert response.status_code == 200
        print(f"Get specific user {user_id} passed")

def test_add_new_user(username, email):
    user_data = {
        "username": username,
        "email": email
    }
    response = requests.post(f"{BASE_URL}/users", json=user_data)
    assert response.status_code == 201
    print("Add new user passed")
    return response.json()['userid']

def test_update_led_strip(device_id, command):
    led_data = {
        "deviceID": device_id,
        "command": command
    }
    response = requests.post(f"{BASE_URL}/publish/{device_id}", json=led_data)
    assert response.status_code == 200
    assert response.text == "Message published"
    print("Update LED strip passed")

def test_get_user_by_email(email):
    user_data = {
        "email": email
    }
    response = requests.post(f"{BASE_URL}/user/email", json=user_data)
    print(response.text)
    if response.status_code == 404:
        print(f"User with email {email} not found")
        print(response.text)
    elif response.status_code == 500:
        print(f"Internal server error occurred: {response.text}")
    else:
        assert response.status_code == 200
        print(f"Get user by email {email} passed")

def test_add_new_device(user_id, device_id, device_name, device_location):
    device_data = {
        "deviceID": device_id,
        "deviceName": device_name,
        "deviceLocation": device_location
    }
    response = requests.post(f"{BASE_URL}/users/{user_id}/devices", json=device_data)
    if response.status_code == 401:
        print("Unauthorized")
    elif response.status_code == 201:
        print("Add new device passed")
        return response.json()
    else:
        print(f"Error occurred: {response.text}")

def test_get_user_devices(user_id):
    response = requests.get(f"{BASE_URL}/users/{user_id}/devices")
    if response.status_code == 401:
        print("Unauthorized")
    elif response.status_code == 200:
        print(response.json())
        print("Get user devices passed")
    else:
        print(f"Error occurred: {response.text}")

def test_delete_device(user_id, device_id):
    response = requests.delete(f"{BASE_URL}/users/{user_id}/devices/{device_id}")
    if response.status_code == 401:
        print("Unauthorized")
    elif response.status_code == 404:
        print("Device not found")
    elif response.status_code == 200:
        print(f"Deleted device: {response.json()}")
    else:
        print(f"Error occurred: {response.text}")

def test_modify_device_name(user_id, device_id, device_name):
    device_data = {
        "deviceName": device_name
    }
    response = requests.put(f"{BASE_URL}/users/{user_id}/devices/{device_id}/name", json=device_data)
    if response.status_code == 401:
        print("Unauthorized")
    elif response.status_code == 404:
        print("Device not found")
    elif response.status_code == 200:
        print(f"Modified device name: {response.json()}")
    else:
        print(f"Error occurred: {response.text}")

def test_modify_device_location(user_id, device_id, device_location):
    device_data = {
        "deviceLocation": device_location
    }
    response = requests.put(f"{BASE_URL}/users/{user_id}/devices/{device_id}/location", json=device_data)
    if response.status_code == 401:
        print("Unauthorized")
    elif response.status_code == 404:
        print("Device not found")
    elif response.status_code == 200:
        print(f"Modified device location: {response.json()}")
    else:
        print(f"Error occurred: {response.text}")

def test_set_effect(device_id, effect):
    effect_data = {
        "effect": effect
    }
    response = requests.post(f"{BASE_URL}/devices/{device_id}/effect", json=effect_data)
    if response.status_code == 404:
        print("Device not found")
    elif response.status_code == 500:
        print("Failed to publish message")
    elif response.status_code == 200:
        print("Set effect passed")
    else:
        print(f"Error occurred: {response.text}")

def test_get_user_patterns(user_id):
    response = requests.get(f"{BASE_URL}/users/{user_id}/patterns")
    if response.status_code == 401:
        print("Unauthorized")
    elif response.status_code == 200:
        print(response.json())
        print("Get user patterns passed")
    else:
        print(f"Error occurred: {response.text}")

def test_delete_pattern(user_id, pattern_id):
    response = requests.delete(f"{BASE_URL}/users/{user_id}/patterns/{pattern_id}")
    if response.status_code == 401:
        print("Unauthorized")
    elif response.status_code == 404:
        print("Pattern not found")
    elif response.status_code == 200:
        print(f"Deleted pattern: {response.json()}")
    else:
        print(f"Error occurred: {response.text}")


def test_delete_all_patterns(user_id):
    response = requests.delete(f"{BASE_URL}/users/{user_id}/patterns")
    if response.status_code == 401:
        print("Unauthorized")
    elif response.status_code == 404:
        print("User not found")
    elif response.status_code == 200:
        print(f"Deleted all patterns: {response.json()}")
    else:
        print(f"Error occurred: {response.text}")


def test_set_pattern(device_id, pattern):
    response = requests.post(f"{BASE_URL}/devices/{device_id}/pattern", json=pattern)
    if response.status_code == 404:
        print("Device not found")
    elif response.status_code == 500:
        print("Failed to publish message")
    elif response.status_code == 200:
        print("Set pattern passed")
    else:
        print(f"Error occurred: {response.text}")

def test_stop_pattern(device_id):
    response = requests.post(f"{BASE_URL}/devices/{device_id}/pattern/stop")
    if response.status_code == 404:
        print("Device not found")
    elif response.status_code == 500:
        print("Failed to publish message")
    elif response.status_code == 200:
        print("Stop pattern passed")
    else:
        print(f"Error occurred: {response.text}")


if __name__ == "__main__":
    test_health_check()
    # test_add_new_user("testuser", "test@gmail.com")
    # test_get_all_users()
    # test_get_user_by_email("justtoni2@gmail.com")
    #Create a device for this user: {'userid': 1, 'username': 'johndoe', 'email': 'test2@gmail.com'}
    # test_add_new_device(1, "4291ca36-c9c3-5fd7-abb8-d74469c7a2f7", "TV Light", "Living Room")
    # test_get_user_devices(1)
    # test_delete_device(1, "4291ca36-c9c3-5fd7-abb8-d74469c7a2f7")
    # test_get_user_devices(1)
    # test_modify_device_name(1, "4291ca36-c9c3-5fd7-abb8-d74469c7a2f7", "Desk Light")
    # test_modify_device_location(1, "4291ca36-c9c3-5fd7-abb8-d74469c7a2f7", "Office")
    # test_delete_all_patterns(4)
    # test_get_user_patterns(1)

    # test_delete_pattern(1, 3)

    # test_update_led_strip(device_id, "000000")
    #Tests the LED strip: DeviceID is 4291ca36-c9c3-5fd7-abb8-d74469c7a2f7
    device_id = "4291ca36-c9c3-5fd7-abb8-d74469c7a2f7"
    #Turn the LED strip on, with green and white repeating pattern
    # test_update_led_strip(device_id, """[[0, 255, 0], [255, 255, 255]]""")
    # test_update_led_strip(device_id, """["FFFFFF"]""")
    #Test the effect
    # test_set_effect(device_id, "Rainbow swirl")
    # test_stop_pattern(device_id)

    pattern_data = {
        "interval": 500,
        "iconColor": "ff2196f3",
        "position1": ["ffffffff", "ff000000"],
        "position2": ["ff000000", "ffffffff"],
        "patternType": "User"
    }
    # test_set_pattern(device_id, pattern_data)