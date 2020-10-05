//
//  BiciApp.swift
//  Bici
//
//  Created by Daniel Jilg on 01.10.20.
//

import SwiftUI

@main
struct BiciApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear() {
                    TelemetryManager.shared.send(.appLaunchedRegularly, for: UIDevice.current.identifierForVendor?.uuidString ?? "!")
                }
        }
    }
}
