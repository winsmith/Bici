//
//  ContentView.swift
//  Bici
//
//  Created by Daniel Jilg on 01.10.20.
//

import SwiftUI
import CoreLocation
import Combine
import MapKit
import TelemetryClient

struct ContentView: View {
    
    var body: some View {
        VStack {
            ContentView2()
            
        }
        
    }
}

struct ContentView2: View {
    let numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 1
        numberFormatter.maximumFractionDigits = 1
        return numberFormatter
    }()
    
    @State var timer = Timer.publish(every: 1, on: .main, in:.common).autoconnect()
    @State var location = CLLocationManager.publishLocation()
    
    @State var locationString = "Lat/Lon"
    @State var speedString = "--"
    @State var courseString = "--"
    
    @State var currentRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    var body: some View {
        
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack {
                Capsule().fill(Color.gray)
                    .frame(maxHeight: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Spacer()
            }
            .ignoresSafeArea()
            
            VStack(alignment: .trailing) {
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("\(speedString)").font(.system(size: 64, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    Text("km/h").font(.system(size: 17, weight: .black, design: .rounded))
                        .foregroundColor(.gray)
                }
                .padding(.bottom)
                
                VStack(alignment: .trailing) {
                    Text("\(courseString)").font(.system(size: 64, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    Text("Direction of Travel").font(.system(size: 17, weight: .black, design: .rounded))
                        .foregroundColor(.gray)
                }
                .padding(.bottom)
                
                VStack(alignment: .trailing) {
                    Text("--").font(.system(size: 64, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    Text("Active Calories Burned").font(.system(size: 17, weight: .black, design: .rounded))
                        .foregroundColor(.gray)
                }
                .padding(.bottom)
                
                VStack(alignment: .trailing) {
                    Text("--:--:--").font(.system(size: 64, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    Text("Time of Workout").font(.system(size: 17, weight: .black, design: .rounded))
                        .foregroundColor(.gray)
                }
                .padding(.bottom)
                
//
//                Map(coordinateRegion: $currentRegion)
//                    .cornerRadius(25)
                Spacer()
                
                
                Text("Location \(locationString)")
                    .font(.system(size: 10, weight: .black, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
            }
            .padding()
            .onReceive(location) { location in
                currentRegion = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
                courseString = directionString(from: location.course)
                speedString = location.speed >= 0 ? "\(numberFormatter.string(from: NSNumber(value: Double(location.speed * 3.6))) ?? "/")" : "0.0"
                locationString = String(format: "%.5f,%.5f %@", location.coordinate.latitude, location.coordinate.longitude, location.timestamp.description)
                
                TelemetryManager.shared.send(TelemetrySignal.gpsUpdateReceived.rawValue)
            }
            .onAppear() {
                UIApplication.shared.isIdleTimerDisabled = true
            }
            .onDisappear() {
                UIApplication.shared.isIdleTimerDisabled = false
            }
        }
        
    }
    
    func directionString(from course: CLLocationDirection) -> String {
        switch course {
        case 0..<45:
            return "N"
        case 45..<135:
            return "E"
        case 135..<225:
            return "S"
        case 225..<315:
            return "W"
        case 315...360:
            return "N"
        default:
            return "--"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
