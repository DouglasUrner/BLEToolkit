//
//  ContentView.swift
//  BLEScanner
//
//  Created by Douglas Urner on 3/22/24.
//

import SwiftUI
import CoreBluetooth

struct ContentView: View {
    
    @ObservedObject private var bleScanner = BLEScanner()
    
    var body: some View {
        VStack {
            // Start/Stop scan
            Button(action: {
                if (self.bleScanner.isScanning) {
                    self.bleScanner.stopScan()
                } else {
                    self.bleScanner.startScan()
                }
            }) {
                if (self.bleScanner.isScanning) {
                    Text("Stop Scan")
                } else {
                    Text("Start Scan")
                }
            }
            .padding()
            .background(self.bleScanner.isScanning ? Color.red : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8.0)
        }
    }
}

#Preview {
    ContentView()
}
