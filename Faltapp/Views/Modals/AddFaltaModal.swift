//
//  AddFaltaModal.swift
//  Faltapp
//
//  Created by Leonel Ferraz Hernandez on 11/08/25.
//

import SwiftUI

struct AddFaltaModal: View {
    
    
    @Environment(\.dismiss) var dismiss
    

    @State private var selectedDates: [Date] = []
    @State private var dateToRemove: Date? = nil
    @State private var showRemoveAlert = false
    
    var onComplete: (([Date]) -> Void)?
    
    init(faltasAtuais: [Date], onComplete: @escaping (([Date]) -> Void)){
        
        self._selectedDates = State(initialValue: faltasAtuais)
        self.onComplete = onComplete
    }
    
    var body: some View {
        
        NavigationView{
            
            VStack(){
                Text("Você pode clicar nos dias em que faltou para adicionar ou remover faltas.")
                    .font(.title2)
                    .padding(.top, 80)
                    .padding(.horizontal, 16)
                    .multilineTextAlignment(.center)
                    
                Spacer()
                
//                DatePicker(
//                    "",
//                    selection: $selectedDate,
//                    displayedComponents: [.date]
//                )
//                .datePickerStyle(.graphical)
//                .padding()
//                Spacer()
                CalendarView(
                    selectedDates: $selectedDates,
                    onDateTap: { date in
                        if selectedDates.contains(where: { Calendar.current.isDate($0, inSameDayAs: date) }) {
                            dateToRemove = date
                            showRemoveAlert = true
                        } else {
                            selectedDates.append(date)
                        }
                    }
                )
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
            .alert("Remover falta?", isPresented: $showRemoveAlert) {
                Button("Cancelar", role: .cancel) { }
                Button("Remover", role: .destructive) {
                    if let date = dateToRemove {
                        selectedDates.removeAll { Calendar.current.isDate($0, inSameDayAs: date) }
                    }
                }
            } message: {
                Text("Tem certeza que deseja remover esta falta?")
            }
            
            
        }//Fim navigation view
        
    }
}

//#Preview {
//    //argumentos necessários para a visualização.
//    AddFaltaModal(faltasAtuais: [], onComplete: <#([Date]) -> Void#>)
//}
