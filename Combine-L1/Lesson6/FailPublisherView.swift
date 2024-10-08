//
//  FailPublisherView.swift
//  Combine-L1
//
//  Created by Evhen Lukhtan on 07.10.2024.
//

import SwiftUI
import Combine

struct FailPublisherView: View {
    @StateObject var viewModel = FailPublisherViewModel()
    
    var body: some View {
        VStack {
            Text("\(viewModel.age)")
                .font(.title)
                .foregroundColor(.green)
                .padding()
            
            TextField("Enter age", text: $viewModel.text)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
                .padding()
            
            Button("Save") {
                viewModel.save()
            }
            
        }
        .alert(item: $viewModel.error) { error in
            Alert(title: Text("Error"), message: Text(error.rawValue))
        }
        
    }
    
}

enum InvalidAgeError: String, Error, Identifiable {
    var id: String { rawValue }
    case lessZero = "Value cann't be sub zero"
    case moreHundred = "Value cann't be more 100"
}

class FailPublisherViewModel: ObservableObject {
    @Published var text = ""
    @Published var age = 0
    @Published var error: InvalidAgeError?
    
    func save() {
        _ = validationPublisher(age: Int(text) ?? -1)
            .sink(receiveCompletion: { [unowned self] complition in
                switch complition {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                }
            }, receiveValue: { [unowned self] value in
                self.age = value
            })
    }
    
    func validationPublisher(age: Int) -> AnyPublisher<Int, InvalidAgeError> {
        if age < 0 {
            return Fail(error: InvalidAgeError.lessZero)
                .eraseToAnyPublisher()
        } else if age > 100 {
            return Fail(error: InvalidAgeError.moreHundred)
                .eraseToAnyPublisher()
        }
        
        return Just(age)
            .setFailureType(to: InvalidAgeError.self)
            .eraseToAnyPublisher()
    }
    
}

#Preview {
    FailPublisherView()
}
