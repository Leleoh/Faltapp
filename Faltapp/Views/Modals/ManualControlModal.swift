//
//  ManualControlModal.swift
//  Faltapp
//
//  Created by Leonel Ferraz Hernandez on 12/08/25.
//

import SwiftUI

struct ManualControlModal: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var faltasPermitidas = ""
    @State private var selectedDates: [Date] = []
    
   
    
    var faltas: Int = 0
    
    
    var body: some View {
        
        NavigationView {
            
            
            
            Form{
                
                Section{
                    Text("Você atualmente tem \(faltas) faltas")
                        .font(.title2)
                        .frame(maxWidth: .infinity)
                        .listRowBackground(Color.clear)
                }
                
                
                Section(header: Text("Faltas permitidas")){
                    TextField("Insira manualmente o limite de faltas", text: $faltasPermitidas)
                        .padding(.leading, 8)
                }
                .foregroundStyle(.white)
                .padding(.leading, -16)
                
                Section{
                    Text("Modifique manualmente as suas faltas")
                        .listRowBackground(Color.clear)
                }
                
                Section{
                    CalendarView(selectedDates: $selectedDates)
                        .frame(height: 350)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 16)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets())
                }
            }//fim do form
            .navigationTitle("Editar matéria")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .confirmationAction){
                    Button("Salvar"){
                        print("Adicionar clicado")
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction){
                    Button("Cancelar"){
                        print("Cancelar clicado")
                        dismiss()
                    }
                }
            }
            
            
            
        }//Fim nav view
        
        
    }
}

#Preview {
    ManualControlModal()
}
