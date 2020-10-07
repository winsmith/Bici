//
//  BiciApp.swift
//  Bici
//
//  Created by Daniel Jilg on 01.10.20.
//

import SwiftUI
import TelemetryClient

@main
struct BiciApp: App {
    let telemetryManager: TelemetryManager = TelemetryManager(configuration: TelemetryManagerConfiguration(appID: "B223CCDB-2348-4847-8011-BD819EB63301"))
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(telemetryManager)
                .onAppear() {
                    telemetryManager.send(TelemetrySignal.appLaunchedRegularly.rawValue)
                }
        }
    }
}
