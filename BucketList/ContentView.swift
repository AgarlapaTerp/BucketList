//
//  ContentView.swift
//  BucketList
//
//  Created by user256510 on 4/21/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 56, longitude: -3), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
    )
    
    @State private var viewModel = ViewModel()
    @State private var mode = MapStyle.standard
    @State private var modeString = "Hybrid"
    
    
    var body: some View {
        VStack {
            if viewModel.isUnlocked {
                ZStack(alignment: .topLeading){
                    MapReader { proxy in
                        Map(initialPosition: startPosition) {
                            ForEach(viewModel.locations) { location in
                                Annotation(location.name, coordinate: location.coordinate) {
                                    Image(systemName: "star.circle")
                                        .resizable()
                                        .foregroundStyle(.red)
                                        .frame(width: 44, height: 44)
                                        .background(.white)
                                        .clipShape(.circle)
                                        .onLongPressGesture {
                                            viewModel.selectedPlace = location
                                        }
                                }
                                
                            }
                            
                            
                        }
                        .onTapGesture { position in
                            if let coordinate = proxy.convert(position, from: .local) {
                                viewModel.addLocation(at: coordinate)
                            }
                        }
                        .sheet(item: $viewModel.selectedPlace){ place in
                            EditView(location: place) { newLocation in
                                viewModel.update(location: newLocation)
                            }
                            
                        }
                        .mapStyle(mode)
                        .alert(viewModel.alertMessage, isPresented: $viewModel.showAlert){ }
                    }
                    
                    Button(modeString){
                        if modeString == "Hybrid" {
                            mode = MapStyle.hybrid
                            modeString = "Standard"
                        } else {
                            mode = MapStyle.standard
                            modeString = "Hybrid"
                        }
                    }
                    .padding()
                }
            } else {
                Button("Unlock places", action: viewModel.authenticate)
                    .padding()
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(.capsule)
            }
        }
    }
    
    
    
}

#Preview {
    ContentView()
}
