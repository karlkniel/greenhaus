import SwiftUI

struct DeviceList: View {
    @StateObject var bluetoothManager = BluetoothManager()
    @State private var scanForDevices = false
    @State private var showScanButton = true
    
    var body: some View {
        NavigationView {
            VStack {
                if scanForDevices {
                    List(bluetoothManager.discoveredPeripherals, id: \.identifier) { peripheral in
                        NavigationLink {
                            DeviceDetail(bluetoothManager: bluetoothManager, device: peripheral)
                        } label: {
                            DeviceRow(device: peripheral)
                        }
                    }
                } else {
                    List(stations) { station in
                        NavigationLink {
                            StationDetail(station: station)
                        } label: {
                            StationRow(station: station)
                        }
                    }
                }
                HStack {
                    Spacer()
                    Button("Scan") {
                        scanForDevices = true
                        bluetoothManager.startScan()
                    }
                    .padding()
                    .buttonStyle(ActionButton())
                }
            }
        }
        .navigationTitle("Devices")
    }
}

#Preview {
    DeviceList()
}
