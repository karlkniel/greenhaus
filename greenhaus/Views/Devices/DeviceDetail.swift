import SwiftUI
import CoreBluetooth

struct DeviceDetail: View {
    @ObservedObject var bluetoothManager: BluetoothManager
    var device: CBPeripheral

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Id: \(device.identifier)")
                        .font(.title3)
                    Button("Connect") {
                        bluetoothManager.connectDevice(device)
                    }
                    .padding()
                    .buttonStyle(ActionButton())
                }
                
                Divider()
                
                if bluetoothManager.peripheralConnected {
                    VStack {
                        Text("Connected")
                            .font(.title)
                        if dataArray.count > 5 {
                            HStack {
                                Text("Air Temperature: \(dataArray[0]) *C")
                                    .font(.title3)
                            }
                            HStack {
                                Text("Humidity: \(dataArray[1]) %")
                                    .font(.title3)
                            }
                            HStack {
                                Text("Soil Temperature: \(dataArray[2]) *C")
                                    .font(.title3)
                            }
                            HStack {
                                Text("Soil Moisture Level: \(dataArray[3]) %")
                                    .font(.title3)
                            }
                            HStack {
                                Text("Atmospheric Pressure: \(dataArray[5]) Pa")
                                    .font(.title3)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(device.name!)
    }
    
    var dataArray: Array<String> {
        return bluetoothManager.peripheralData.components(separatedBy: ",")
    }
}
