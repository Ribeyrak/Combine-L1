//
//  ContentView.swift
//  Combine-L1
//
//  Created by Evhen Lukhtan on 06.09.2024.
//

import SwiftUI
import Combine

/// "❌"
/// "✅"

struct FirstPipelineView: View {
    
    @StateObject var viewModel = FirstPipelineViewModel()
    
    var body: some View {
        HStack {
            TextField("Your name", text: $viewModel.name)
                .textFieldStyle(.roundedBorder)
            Text(viewModel.validation)
        }
        .padding()
    }
}

class FirstPipelineViewModel: ObservableObject {
    @Published var name = ""
    @Published var validation = ""

    init() {
        $name
            .map { $0.isEmpty ? "❌" : "✅" }
            .assign(to: &$validation)
    }
    
}

#Preview {
    FirstPipelineView()
}
