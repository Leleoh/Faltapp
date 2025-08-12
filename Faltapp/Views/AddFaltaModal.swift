//
//  AddFaltaModal.swift
//  Faltapp
//
//  Created by Leonel Ferraz Hernandez on 11/08/25.
//

import SwiftUI

struct AddFaltaModal: View {
    
    
    @Environment(\.dismiss) var dismiss
    
//    @State private var selectedDate = Date()
    @State private var selectedDates: [Date] = []
    
    var onComplete: (([Date]) -> Void)?
    
    init(faltasAtuais: [Date], onComplete: @escaping (([Date]) -> Void)){
        
        self._selectedDates = State(initialValue: faltasAtuais)
        self.onComplete = onComplete
    }
    
    var body: some View {
        
        NavigationView{
            
            VStack(){
                Text("Você pode clicar nos dias em que faltou para registrar uma falta")
                    .padding(.top, 80)
                Spacer()
                
//                DatePicker(
//                    "",
//                    selection: $selectedDate,
//                    displayedComponents: [.date]
//                )
//                .datePickerStyle(.graphical)
//                .padding()
//                Spacer()
                CalendarView(selectedDates: $selectedDates)
                    .frame(height: 350)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 16)
                Spacer()
            }
                        
            .navigationTitle(Text("Registrar Falta"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .confirmationAction){
                    Button("Adicionar"){
                        print("Faltas: \(selectedDates)")
                        onComplete?(selectedDates)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction){
                    Button("Cancelar"){
                        dismiss()
                    }
                }
            }
            
            
        }//Fim navigation view
        
    }
}

//#Preview {
//    //argumentos necessários para a visualização.
//    AddFaltaModal()
//}
