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

struct ContentView: View {
    
    var body: some View {
        VStack {
            ContentView2()
            
        }
        
    }
}

struct ContentView2: View {
    
    let numberFormatter = NumberFormatter()
    
    @State var timer = Timer.publish(every: 1, on: .main, in:.common).autoconnect()
    @State var location = CLLocationManager.publishLocation()
    
    @State var locationString = "Lat/Lon"
    @State var speedString = "–"
    @State var courseString = "–"
    
    @State var currentRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    var body: some View {
        
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(alignment: .trailing) {
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("\(speedString)").font(.system(size: 64, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    Text("km/h").font(.system(size: 17, weight: .black, design: .rounded))
                        .foregroundColor(.gray)
                }
                
                VStack(alignment: .trailing) {
                    Text("\(courseString)").font(.system(size: 64, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    Text("Course Degrees").font(.system(size: 17, weight: .black, design: .rounded))
                        .foregroundColor(.gray)
                }
                
                VStack(alignment: .trailing) {
                    Text("–").font(.system(size: 64, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    Text("Active Calories Burned").font(.system(size: 17, weight: .black, design: .rounded))
                        .foregroundColor(.gray)
                }
                
                VStack(alignment: .trailing) {
                    Text("–").font(.system(size: 64, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    Text("Time of Workout").font(.system(size: 17, weight: .black, design: .rounded))
                        .foregroundColor(.gray)
                }
                
                
                Map(coordinateRegion: $currentRegion)
                    .cornerRadius(25)
                
                
                Text("Location \(locationString)")
                    .font(.system(size: 10, weight: .black, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
            }
            .padding()
            .onReceive(location) { location in
                currentRegion = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
                courseString = location.course >= 0 ? "\(numberFormatter.string(from: NSNumber(value: location.course)) ?? "/")" : "–"
                speedString = location.speed >= 0 ? "\(numberFormatter.string(from: NSNumber(value: Double(location.speed * 3.6))) ?? "/")" : "–"
                locationString = String(format: "%.5f,%.5f %@", location.coordinate.latitude, location.coordinate.longitude, location.timestamp.description)
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
