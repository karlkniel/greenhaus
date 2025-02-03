import SwiftUI

struct DevicesView: View {
    @StateObject var bluetoothManager = BluetoothManager()
    @State private var scanForDevices = false
    @State private var showScanButton = true
    
    var body: some View {
        NavigationView {
            VStack {
                if scanForDevices {
                    HStack {
                        List(bluetoothManager.discoveredPeripherals, id: \.identifier) { peripheral in
                            NavigationLink {
                                DeviceDetail(bluetoothManager: bluetoothManager, device: peripheral)
                            } label: {
                                DeviceRow(device: peripheral)
                            }
                        }
                    }
                    HStack {
                        Spacer()
                        Button("Stop Scan") {
                            scanForDevices = false
                            bluetoothManager.stopScan()
                        }
                        .padding()
                        .buttonStyle(StopButton())
                    }
                } else {
                    VStack {
                        Spacer()
                        Button("Scan") {
                            scanForDevices = true
                            bluetoothManager.startScan()
                        }
                        .padding()
                        .buttonStyle(StartButton())
                    }
                }
            }
        }
        .navigationTitle("Devices")
    }
}

#Preview {
    DevicesView()
}
