import SwiftUI
import CoreBluetooth

struct DeviceRow: View {
    var device: CBPeripheral

    var body: some View {
        HStack {
            Text(device.name!)
            Spacer()
        }
    }
}

