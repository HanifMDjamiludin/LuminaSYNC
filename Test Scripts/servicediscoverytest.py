from zeroconf import ServiceBrowser, Zeroconf

class ServiceListener:
    def remove_service(self, zeroconf, type, name):
        print(f"Service {name} removed")

    def add_service(self, zeroconf, type, name):
        info = zeroconf.get_service_info(type, name)
        if info:
            addresses = [str(addr) for addr in info.parsed_addresses()]
            print(f"\nService {name} added:")
            print(f"  Address(es): {', '.join(addresses)}")
            print(f"  Port: {info.port}")
            print(f"  Weight: {info.weight}")
            print(f"  Priority: {info.priority}")
            print(f"  Server: {info.server}")
            properties = {key.decode(): value.decode() for key, value in info.properties.items()}
            for key, value in properties.items():
                print(f"  {key}: {value}")

    def update_service(self, zeroconf, type, name):
        print(f"Service {name} updated")

def discover_services():
    zeroconf = Zeroconf()
    services = ["_hyperiond-json._tcp.local."]
    listener = ServiceListener()
    browser = ServiceBrowser(zeroconf, services[0], listener)

    print("Service discovery started. Press Ctrl+C to exit...")
    try:
        # Keep the program running to allow service discovery
        input()
    except KeyboardInterrupt:
        pass
    finally:
        zeroconf.close()

if __name__ == "__main__":
    discover_services()
