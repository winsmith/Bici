//
//  ContentView.swift
//  Bici
//
//  Created by Daniel Jilg on 01.10.20.
//

import SwiftUI
import CoreData
import CoreLocation
import Combine

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
    @State var courseString = "–º"
    
    var body: some View {
        
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(alignment: .trailing) {
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("\(speedString)").font(.system(size: 64, weight: .black, design: .monospaced))
                    Text("km/h").font(.system(size: 17, weight: .black, design: .monospaced))
                }
                
                VStack(alignment: .trailing) {
                    Text("\(courseString)").font(.system(size: 64, weight: .black, design: .monospaced))
                    Text("Degrees").font(.system(size: 17, weight: .black, design: .monospaced))
                }
                
                Spacer()
                
                Text("Location \(locationString)")
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
            }
            .foregroundColor(.white)
            .onReceive(location) { location in
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
