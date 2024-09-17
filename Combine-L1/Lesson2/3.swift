//
//  3.swift
//  Combine-L1
//
//  Created by Evhen Lukhtan on 16.09.2024.
//

import SwiftUI
import Combine

struct FirstCancellablePipelineView2: View {
    
    @StateObject var viewModel: FirstCancellablePipelineViewModel2
    
    init(viewModel: FirstCancellablePipelineViewModel2 = FirstCancellablePipelineViewModel2()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            HStack {
                TextField("Your name...", text: $viewModel.name)
                    .textFieldStyle(.roundedBorder)
                Text(viewModel.validation)
            }
            .padding()
            
            Button(viewModel.isSubscribed ? "Unsubscribe" : "Subscribe") {
                viewModel.toggleSubscription()
            }
        }
    }
}

class FirstCancellablePipelineViewModel2: ObservableObject {
    @Published var name = ""
    @Published var validation = ""
    var anyCancellable: AnyCancellable?
    
    var isSubscribed: Bool {
        anyCancellable != nil
    }
    
    init() {
        subscribe()
    }
    
    func subscribe() {
        anyCancellable = $name
            .map { $0.isEmpty ? "❌" : "✅" }
            .sink { [weak self] value in
                self?.validation = value
            }
    }
    
    func unsubscribe() {
        anyCancellable?.cancel()
        anyCancellable = nil
    }
    
    func toggleSubscription() {
        if isSubscribed {
            unsubscribe()
            validation = ""
        } else {
            subscribe()
        }
    }
}

#Preview {
    FirstCancellablePipelineView2()
}
