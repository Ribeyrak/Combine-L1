//
//  FirstCancellablePipelineView.swift
//  Combine-L1
//
//  Created by Evhen Lukhtan on 16.09.2024.
//

import SwiftUI
import Combine

/// "❌"
/// "✅"

struct FirstCancellablePipelineView: View {
    
    @StateObject var viewModel = FirstCancellablePipelineViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            Text(viewModel.data)
                .font(.title)
                .foregroundStyle(.green)
            
            Text(viewModel.status)
                .foregroundStyle(.blue)
            
            Spacer()
            
            Button {
                viewModel.cancel()
            } label: {
                Text("Cancel subs")
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
            }
            .background(.red)
            .cornerRadius(8)
            .opacity(viewModel.status == "Request to server" ? 1.0 : 0.0)
            
            Button {
                viewModel.refresh()
            } label: {
                Text("Data request..")
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
            }
            .background(.blue)
            .cornerRadius(8)
            .padding()
            
        }
        
    }
}

class FirstCancellablePipelineViewModel: ObservableObject {
    @Published var data = ""
    @Published var status = ""

    private var cancellable: AnyCancellable?
    
    init() {
        cancellable = $data
            .map { [unowned self] value -> String in
                status = "Request to server"
                return value
            }
            .delay(for: 5, scheduler: DispatchQueue.main)
            .sink { [unowned self] _ in
                data = "Value $100"
                status = "Data was recived"
            }
    }
    
    func refresh() {
        data = "Data update"
    }
    
    func cancel() {
        status = "Operations was cancel"
        cancellable?.cancel()
        cancellable = nil
    }
}

#Preview {
    FirstCancellablePipelineView()
}

