//
//  LocationHeadingProxy.swift
//  Bici
//
//  https://stackoverflow.com/a/59383762/54547
//

// Requirements: a NSLocationWhenInUseUsageDescription entry in Info.plist
// Usage:  @State var locator = CLLocationManager.publishLocation()
//           and
//         .onReceive(locator) { location in
// Improvements needed: Move requestWhenInUseAuthorization into its own publisher and perhaps have a combineLatest pipeline for both authorized and valid location.
//  A configuration param to init(), so each manager can have the same distanceFilter.

import Foundation
import Combine
import CoreLocation
import UIKit

extension CLLocationManager {
    public static func publishLocation() -> LocationPublisher{
        return .init()
    }

    public struct LocationPublisher: Publisher {
        public typealias Output = CLLocation
        public typealias Failure = Never

        public func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            let subscription = LocationSubscription(subscriber: subscriber)
            subscriber.receive(subscription: subscription)
        }
        
        final class LocationSubscription<S: Subscriber> : NSObject, CLLocationManagerDelegate, Subscription where S.Input == Output, S.Failure == Failure {
            var subscriber: S
            var locationManager = CLLocationManager()
            
            init(subscriber: S) {
                self.subscriber = subscriber
                super.init()
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            }

            func request(_ demand: Subscribers.Demand) {
                locationManager.startUpdatingLocation()
                locationManager.requestWhenInUseAuthorization()
            }
            
            func cancel() {
                locationManager.stopUpdatingLocation()
            }
            
            func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
                for location in locations {
                    _ = subscriber.receive(location)
                }
            }
        }
    }
}
