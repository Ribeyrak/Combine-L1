//
//  CancellingMultiplePipelinesView.swift
//  Combine-L1
//
//  Created by Evhen Lukhtan on 17.09.2024.
//

import SwiftUI
import Combine

struct CancellingMultiplePipelinesView: View {
    
    @StateObject private var viewModel: CancellingMultiplePipelinesViewModel
    
    init(viewModel: CancellingMultiplePipelinesViewModel = CancellingMultiplePipelinesViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Group {
            HStack {
                TextField("Name", text: $viewModel.firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text(viewModel.firstNameValidation)
            }
            
            HStack {
                TextField("Lastname", text: $viewModel.lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text(viewModel.lastNameValidation)
            }
            
        }
        .padding()
        
        Button {
            viewModel.cancelAllValidations()
        } label: {
            Text("Remove all checks")
        }
        
        Button("Remove all subs") { viewModel.cancelAllValidations() }

    }
    
}

class CancellingMultiplePipelinesViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var firstNameValidation: String = ""
    
    @Published var lastName: String = ""
    @Published var lastNameValidation: String = ""
    
    private var validationCancelables: Set<AnyCancellable> = []
    private var cancelables = Set<AnyCancellable>()
    
    init() {
        $firstName
            .map { $0.isEmpty ? "❌" : "✅"  }
            .sink { [unowned self] value in
                firstNameValidation = value
            }
            .store(in: &cancelables)
        
        $lastName
            .map {$0.isEmpty ? "❌" : "✅" }
            .sink { [unowned self] value in
                lastNameValidation = value
            }
            .store(in: &cancelables)
    }
    
    func cancelAllValidations() {
        firstNameValidation = ""
        lastNameValidation = ""
        cancelables.removeAll()
    }
}

#Preview {
    CancellingMultiplePipelinesView()
}
