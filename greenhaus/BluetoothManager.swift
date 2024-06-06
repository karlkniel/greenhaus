import CoreBluetooth
import SwiftUI

class BluetoothManager: NSObject, CBCentralManagerDelegate, ObservableObject, CBPeripheralDelegate {
    
    @Published var discoveredPeripherals = [CBPeripheral]()
    @Published var peripheralConnected = false
    @Published var peripheralData = ""

    var centralManager: CBCentralManager!
    
    let BLE_Service_UUID = CBUUID(string: "6e400001-b5a3-f393-e0a9-e50e24dcca9e")
    let BLE_Characteristic_uuid_Rx = CBUUID(string: "6e400003-b5a3-f393-e0a9-e50e24dcca9e")
    let BLE_Characteristic_uuid_Tx  = CBUUID(string: "6e400002-b5a3-f393-e0a9-e50e24dcca9e")

    override init() {
        super.init()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
            case .poweredOn:
                print("bluetooth is on")
            case .poweredOff:
                print("bluetooth is off")
            case .unauthorized:
                print("bluetooth not enabled for this app")
            case .unsupported:
                print("bluetooth not supported for this device")
            case .resetting:
                print("bluetooth resetting...")
            case .unknown:
                print("bluetooth state unknown")
            @unknown default:
                print("bluetooth state default")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !discoveredPeripherals.contains(peripheral) && peripheral.name != nil {
            self.discoveredPeripherals.append(peripheral)
        }
    }
    
    func startScan() {
        print("scanning...")
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func stopScan() {
        self.centralManager.stopScan()
    }
    
    func connectDevice(_ peripheral: CBPeripheral) {
        stopScan()
        print("connecting...")
        centralManager.connect(peripheral)
    }
    
    func disconnectDevice(_ peripheral: CBPeripheral) {
        centralManager.cancelPeripheralConnection(peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("successfully connected to device: \(String(describing: peripheral.name))")
        stopScan()
        peripheral.delegate = self
        peripheralConnected = true
        peripheral.discoverServices([BLE_Service_UUID])
    }
     
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("error connecting to device: \(String(describing: peripheral.name))")
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: (any Error)?) {
        if let error = error {
            print("error disconnecting from device \(String(describing: peripheral.name))")
            return
        }
        print("successfully disconnected from device: \(String(describing: peripheral.name))")
        peripheralConnected = false
    }
    
    func discoverCharacteristics(peripheral: CBPeripheral) {
        guard let services = peripheral.services else {
            return
        }
        for service in services {
            if service.uuid == BLE_Service_UUID {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func readValue(characteristic: CBCharacteristic) {
        BlePeripheral.connectedPeripheral?.readValue(for: characteristic)
        return
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: (any Error)?) {
        guard let services = peripheral.services else {
            return
        }
        discoverCharacteristics(peripheral: peripheral)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: (any Error)?) {
        if ((error) != nil) {
            print("Error discovering services: \(error!.localizedDescription)")
            return
        }
        guard let characteristics = service.characteristics else {
            return
        }
        for characteristic in characteristics {
            if characteristic.uuid.isEqual(BLE_Characteristic_uuid_Rx)  {
                BlePeripheral.connectedRXChar = characteristic
                
                peripheral.setNotifyValue(true, for: BlePeripheral.connectedRXChar!)
                peripheral.readValue(for: characteristic)
                print("Rx Characteristic: \(characteristic.uuid)")
            }
            peripheral.discoverDescriptors(for: characteristic)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if (error != nil) {
            print("Error changing notification state:\(String(describing: error?.localizedDescription))")
        } else {
            print("Characteristic's value subscribed")
        }

        if (characteristic.isNotifying) {
            print ("Subscribed. Notification has begun for: \(characteristic.uuid)")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
        guard characteristic == BlePeripheral.connectedRXChar,
        let characteristicValue = characteristic.value,
        let receivedString = NSString(data: characteristicValue, encoding: String.Encoding.utf8.rawValue)
        else { return }
        
        print("received: \(receivedString)")
        peripheralData = receivedString as String
        
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: "Notify"), object: self)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            print("\(error.debugDescription)")
            return
        }
        
        guard let descriptors = characteristic.descriptors else {
            return
        }
            
        // For every descriptor, print its description for debugging purposes
        descriptors.forEach { descript in
            print("function name: DidDiscoverDescriptorForChar \(String(describing: descript.description))")
            print("Rx Value \(String(describing: BlePeripheral.connectedRXChar?.value))")
            print("Tx Value \(String(describing: BlePeripheral.connectedTXChar?.value))")
        }
    }
}
