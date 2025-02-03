import SwiftUI
import CoreBluetooth

struct DeviceDetail: View {
    @ObservedObject var bluetoothManager: BluetoothManager
    var device: CBPeripheral

    var body: some View {
        NavigationView {
            VStack {
                if bluetoothManager.peripheralConnected {
                    VStack {
                        Text("Connected")
                            .font(.title)
                        if dataArray.count > 5 {
                            let airTemp = dataArray[0]
                            let airTempFloat = (airTemp as NSString).doubleValue
                            let rH = dataArray[1]
                            let rHFloat = (rH as NSString).doubleValue
                            let svp = 610.78 * pow(2.71828, (airTempFloat / (airTempFloat+237.3) * 17.2694))
                            let vpd = svp * (1 - (rHFloat/100)) / 1000
                            HStack {
                                Text("Air Temperature: \(airTemp) *C")
                                    .font(.title3)
                                    .padding()
                            }
                            HStack {
                                Text("Humidity: \(rH) %")
                                    .font(.title3)
                                    .padding()
                            }
                            HStack {
                                Text("Soil Temperature: \(dataArray[2]) *C")
                                    .font(.title3)
                                    .padding()
                            }
                            HStack {
                                Text("Soil Moisture Level: \(dataArray[3]) %")
                                    .font(.title3)
                                    .padding()
                            }
                            HStack {
                                Text("BMP Temperature: \(dataArray[4]) *C")
                                    .font(.title3)
                                    .padding()
                            }
                            HStack {
                                Text("Atmospheric Pressure: \(dataArray[5]) Pa")
                                    .font(.title3)
                                    .padding()
                            }
                            HStack {
                                Text("Air VPD: \(String(format: "%.2f", vpd)) Pa")
                                    .font(.title3)
                                    .padding()
                            }
                        }
                        HStack {
                            Text("Id: \(device.identifier)")
                                .font(.title2)
                            Button("Disconnect") {
                                bluetoothManager.disconnectDevice(device)
                            }
                            .padding()
                            .buttonStyle(StopButton())
                        }
                    }
                } else {
                    VStack {
                        Text("Id: \(device.identifier)")
                            .font(.title2)
                        Button("Connect") {
                            bluetoothManager.connectDevice(device)
                        }
                        .padding()
                        .buttonStyle(StartButton())
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
