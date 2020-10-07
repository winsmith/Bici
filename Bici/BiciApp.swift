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
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear() {
                    TelemetryManager.shared.send(TelemetrySignal.appLaunchedRegularly.rawValue)
                }
        }
    }
    
    init() {
        let configuration = TelemetryManagerConfiguration(appID: "B223CCDB-2348-4847-8011-BD819EB63301")
        TelemetryManager.initialize(with: configuration)
    }
}
