//
//  AddFaltaModal.swift
//  Faltapp
//
//  Created by Leonel Ferraz Hernandez on 11/08/25.
//

import SwiftUI

struct AddFaltaModal: View {
    
    @Environment(\.dismiss) var dismiss
    
    var materia: Materia
    @State private var selectedDates: [Date] = []
    @State private var dateToRemove: Date? = nil
    @State private var showRemoveAlert = false
    
    @State private var showOptionsDialog = false
    @State private var datePendingOption: Date? = nil
    
    var onComplete: (([Date]) -> Void)?
    
    init(materia: Materia, onComplete: @escaping (([Date]) -> Void)){
        self.materia = materia
        self._selectedDates = State(initialValue: materia.datasFaltas)
        self.onComplete = onComplete
    }
    
    private func creditsForDate(_ date: Date) -> Int {
        let weekday = Calendar.current.component(.weekday, from: date)
        switch weekday {
        case 2: return materia.faltasSegunda > 0 ? materia.faltasSegunda : 2
        case 3: return materia.faltasTerca > 0 ? materia.faltasTerca : 2
        case 4: return materia.faltasQuarta > 0 ? materia.faltasQuarta : 2
        case 5: return materia.faltasQuinta > 0 ? materia.faltasQuinta : 2
        case 6: return materia.faltasSexta > 0 ? materia.faltasSexta : 2
        case 7: return materia.faltasSabado > 0 ? materia.faltasSabado : 2
        default: return 2
        }
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
                
                CalendarView(
                    materia: materia,
                    selectedDates: $selectedDates,
                    onDateTap: { date in
                        if selectedDates.contains(where: { Calendar.current.isDate($0, inSameDayAs: date) }) {
                            dateToRemove = date
                            showRemoveAlert = true
                        } else {
                            let credits = creditsForDate(date)
                            if credits == 4 {
                                datePendingOption = date
                                showOptionsDialog = true
                            } else {
                                selectedDates.append(date)
                            }
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
                    Button("Salvar"){
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
            .confirmationDialog("Registrar Falta", isPresented: $showOptionsDialog, titleVisibility: .visible) {
                Button("Falta Integral (2 faltas / 4 períodos)") {
                    if let date = datePendingOption {
                        selectedDates.append(date)
                        selectedDates.append(date)
                    }
                }
                Button("Falta Parcial (1 falta / 2 períodos)") {
                    if let date = datePendingOption {
                        selectedDates.append(date)
                    }
                }
                Button("Cancelar", role: .cancel) {
                    datePendingOption = nil
                }
            } message: {
                Text("Esta matéria possui 4 períodos neste dia. Deseja registrar falta integral ou parcial?")
            }
            
            
        }//Fim navigation view
        
    }
}

