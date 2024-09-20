//
//  CurrentValueSubjectView.swift
//  Combine-L1
//
//  Created by Evhen Lukhtan on 19.09.2024.
//

import SwiftUI
import Combine

///     @Published                                    @CurrentValueSubject
///     1. Запускается pipeline                1. Устанавливается значение
///     2. Устанавливается значение     2. Запускается pipeline
///     3. UI автоматом                             3. UI update by ojectWillChange.send()

struct CurrentValueSubjectView: View {
    
    @StateObject private var viewModel: CurrentValueSubjectViewModel
    
    init(viewModel: CurrentValueSubjectViewModel = CurrentValueSubjectViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        VStack {
            Text("\(viewModel.selectionSame.value ? "Selected twice" : "") \(viewModel.selection.value)")
                .foregroundStyle(viewModel.selectionSame.value ? .red : .green)
                .padding()
            
            Button("Choose cola") {
                viewModel.selection.value = "Cola"
                //viewModel.selection.send("Cola")
            }
            .padding()
            
            Button("Choose burger") {
                //viewModel.selection.value = "Burger"
                viewModel.selection.send("Burger")
            }
            .padding()
        }
        
    }
    
}

class CurrentValueSubjectViewModel: ObservableObject {
    
    var selection = CurrentValueSubject<String, Never>("Cart empty")
    var selectionSame = CurrentValueSubject<Bool, Never>(false)
    
    var cancelables = Set<AnyCancellable>()
    
    init() {
        selection
            .map { [unowned self] newValue -> Bool in
                if newValue == selection.value { return true } else { return false }
            }
            .sink { [unowned self] value in
                selectionSame.value = value
                objectWillChange.send()
            }
            .store(in: &cancelables)
    }
    
}

#Preview {
    CurrentValueSubjectView()
}
