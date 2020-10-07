//
//  Telemetry
//
//  Created by Daniel Jilg on 27.11.19.
//  Copyright © 2019 breakthesystem. All rights reserved.
//

import Foundation
import TelemetryClient

enum TelemetrySignal: String {
    case appLaunchedRegularly
    case gpsUpdateReceived
}

extension TelemetryManager: ObservableObject {}
