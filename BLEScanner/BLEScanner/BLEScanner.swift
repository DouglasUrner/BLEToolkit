//
//  BLEScanner.swift
//  BLEScanner
//
//  Created by Douglas Urner on 3/23/24.
//

import Foundation
import CoreBluetooth

struct DiscoveredPeripheral {
    var peripheral: CBPeripheral
}

class BLEScanner: NSObject, CBCentralManagerDelegate, ObservableObject {
    @Published var discoveredPeripherals = [DiscoveredPeripheral]()
    @Published var isScanning = false
    
    var centralManager: CBCentralManager!
    
    var discoveredPeripheralsSet = Set<CBPeripheral>()
    var timer: Timer?
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
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
        }
    }
    
    func stopScan() {
        timer?.invalidate()
        centralManager.stopScan()
        isScanning = false
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

