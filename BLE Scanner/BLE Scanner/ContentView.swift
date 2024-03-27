//
//  ContentView.swift
//  BLE Scanner
//
//  Created by Douglas Urner on 3/23/24.
//

import SwiftUI
import CoreBluetooth

struct ContentView: View {
    
    @ObservedObject private var bleScanner = BLEScanner()
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            HStack {
                // Text field for entering search text
                TextField("Search", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                // Button for clearing search text
                Button(action: {
                    self.searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(PlainButtonStyle())
                .opacity(searchText == "" ? 0 : 1)
            }
            .padding()
            
            // List of discovered peripherals filtered by search text
            List(bleScanner.discoveredPeripherals.filter {
                self.searchText.isEmpty ? true : $0.peripheral.name?.lowercased().contains(self.searchText.lowercased()) == true
            }, id: \.peripheral.identifier) { discoveredPeripheral in
                DisclosureGroup("\(discoveredPeripheral.peripheral.name ?? "Unknown Device")\t\tRSSI: \(discoveredPeripheral.rssi) dB\tTimestamp: \(discoveredPeripheral.timestamp)") {
                    //Text(discoveredPeripheral.peripheral.name ?? "Unknown Device")
                    Text(discoveredPeripheral.advertisedData)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        
        VStack {
            Button(action: {
                if (self.bleScanner.isScanning) {
                    self.bleScanner.stopScan()
                } else {
                    self.bleScanner.startScan()
                }
            }) {
                if (self.bleScanner.isScanning) {
                    Text("Stop Scanning")
                } else {
                    Text("Start Scanning")
                }
            }
        }
        .padding()
        .background(self.bleScanner.isScanning ? Color.red : Color.blue)
        .foregroundColor(.white)
        .cornerRadius(8.0)
    }
}

#Preview {
    ContentView()
}
