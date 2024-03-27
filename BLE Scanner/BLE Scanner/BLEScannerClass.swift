//
//  BLEScannerClass.swift
//  BLE Scanner
//
//  Created by Douglas Urner on 3/23/24.
//

import Foundation
import CoreBluetooth

struct DiscoveredPeripheral {
    var peripheral: CBPeripheral
    var rssi: NSNumber
    var timestamp: String
    var advertisedData: String
}

class BLEScanner: NSObject, CBCentralManagerDelegate, ObservableObject {
    @Published var discoveredPeripherals = [DiscoveredPeripheral]()
    @Published var isPoweredOn = false
    @Published var isScanning = false
    
    var centralManager: CBCentralManager!
    
    var discoveredPeripheralsSet = Set<CBPeripheral>()
    var timer: Timer?
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        centralManager.delegate = self
    }
    
    func startScan() {
        if (centralManager.state == .poweredOn) {
            // Clear out any peripherals discovered on previous scans.
            discoveredPeripherals.removeAll()
            discoveredPeripheralsSet.removeAll()
            
            objectWillChange.send()
            centralManager.scanForPeripherals(withServices: nil)
            
            isScanning = true
        } else {
            // XXX explain why we can't start
            print("startScan(): unable to start scanning, central.state is \(centralManager.state)")
        }
    }
    
    func stopScan() {
        timer?.invalidate()
        centralManager.stopScan()
        isScanning = false
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        // Build a string representation of the advertised data and sort it by names
        var advertisedData = advertisementData.map { "\($0): \($1)" }.sorted(by: { $0 < $1 }).joined(separator: "\n")

        // Convert the timestamp into human readable format and insert it to the advertisedData String
        let timestampValue = advertisementData["kCBAdvDataTimestamp"] as! Double
        // print(timestampValue)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let dateString = dateFormatter.string(from: Date(timeIntervalSince1970: timestampValue))

        // advertisedData = "actual rssi: \(RSSI) dB\n" + "Timestamp: \(dateString)\n" + advertisedData

        // If the peripheral is not already in the list
        if !discoveredPeripheralsSet.contains(peripheral) {
            // Add it to the list and the set
            discoveredPeripherals.append(DiscoveredPeripheral(peripheral: peripheral, rssi: RSSI, timestamp: dateString, advertisedData: advertisedData))
            discoveredPeripheralsSet.insert(peripheral)
            objectWillChange.send()
        } else {
            // If the peripheral is already in the list, update its advertised data
            if let index = discoveredPeripherals.firstIndex(where: { $0.peripheral == peripheral }) {
                discoveredPeripherals[index].advertisedData = advertisedData
                objectWillChange.send()
            }
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
            // XXX Need to support some sort of trace / error logging -- at least in a debug mode.
        case .unknown:
            // XXX -- throw error?
            print("central.state is .unknown")
            stopScan()
        case .resetting:
            print("central.state is .resetting")
            stopScan()
        case .unsupported:
            print("central.state is .unsupported")
            stopScan()
        case .unauthorized:
            print("central.state is .unauthorized")
            stopScan()
        case .poweredOff:
            print("central.state is .poweredOff")
            stopScan()
        case .poweredOn:
            print("central.state is .poweredOn")
            startScan()
        @unknown default:
            print("central.state is unknown")
        }
    }
}
