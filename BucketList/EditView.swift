//
//  EditView.swift
//  BucketList
//
//  Created by user256510 on 4/23/24.
//

import SwiftUI

struct EditView: View {
    @State private var viewModel:ViewModel
    @Environment(\.dismiss) var dismiss
    
    var onSave: (Location) -> Void
   
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Place name", text: $viewModel.name)
                    
                    TextField("Description", text: $viewModel.description)
                }
                
                Section("Nearby...") {
                    switch viewModel.loadingState {
                    case .loading:
                        Text("Loading...")
                    case .loaded:
                        ForEach(viewModel.pages, id: \.pageid) { page in
                            Text("\(page.title): \(page.description)" )
                        }
                    case .failed:
                        Text("Please try again later")
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                Button("Save") {
                    var newLocation = viewModel.save()
                    onSave(newLocation)
                    dismiss()
                }
            }
            .task {
                await viewModel.fetchNearbyPlaces()
            }
        }
    }
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.onSave = onSave
        _viewModel = State(initialValue: ViewModel(location: location))
    }
    
    
}

#Preview {
    EditView(location: .example, onSave: {_ in })
}
