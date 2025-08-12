//
//  Stepper.swift
//  Faltapp
//
//  Created by Leonel Ferraz Hernandez on 11/08/25.
//

import SwiftUI

struct FaltaStepper: View {
    
    @Binding var value: Int
    var range: ClosedRange<Int> = 0...Int.max
    var step: Int = 1
    var minValue: Int = 0
    
    
    
    var body: some View {
        
        HStack{
            Button(action: {
                value = max(minValue, value - step)
            }) {
                Image(systemName: "minus")
                    .frame(width: 20, height: 20)
            }
            .foregroundStyle(.secondary)
            .buttonStyle(.bordered)
            .padding(.trailing, 4)
        
            Text("\(value)")
                .frame(width: 20)
                .multilineTextAlignment(.center)
            
            Button(action: {
                value += step
            }) {
                Image(systemName: "plus")
                    .frame(width: 20, height: 20)
            }
            .foregroundStyle(.secondary)
            .buttonStyle(.bordered)
            .padding(.leading, 4)
            
        }
        
    }
}

#Preview {
    StatefulPreviewWrapper(0) { binding in
        FaltaStepper(value: binding)
    }
}

// Helper para previews com Binding
struct StatefulPreviewWrapper<Value>: View {
    @State var value: Value
    var content: (Binding<Value>) -> AnyView

    init(_ value: Value, content: @escaping (Binding<Value>) -> some View) {
        _value = State(initialValue: value)
        self.content = { binding in AnyView(content(binding)) }
    }

    var body: some View {
        content($value)
    }
}
