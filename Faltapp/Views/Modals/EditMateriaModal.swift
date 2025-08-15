//
//  EditMateriaModal.swift
//  Faltapp
//
//  Created by Leonel Ferraz Hernandez on 12/08/25.
//

import SwiftUI
import SwiftData

struct EditMateriaModal: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var nome = ""
    
    //States
//    @State private var faltasSegunda = 0
//    @State private var faltasTerca = 0
//    @State private var faltasQuarta = 0
//    @State private var faltasQuinta = 0
//    @State private var faltasSexta = 0
//    @State private var faltasSabado = 0
    
    @State private var showManualControlModal: Bool = false
    
    @Bindable var materia: Materia
    
    
    var body: some View {
        
        NavigationView{
            
            
            Form{
                Section(header: Text("Nome da matéria")){
                    TextField("Nome atual da matéria", text: $materia.titulo)
                        .padding(.leading, 8)
                }
                .foregroundStyle(.white)
                .padding(.leading, -16)
                
//                Section(header: Text("Nome da matéria")){
//                    TextField("Nome atual da matéria", text: $materia.titulo)
//                        .padding(.leading, 8)
//                }
//                .foregroundStyle(.white)
//                .padding(.leading, -16)
//                .padding(.top, -16)
                
                
                
                Section{
                    HStack{
                        Text("Segunda-feira")
                        Spacer()
                        FaltaStepper(value: $materia.faltasSegunda)
                    }
                }
                
                Section{
                    HStack{
                        Text("Terça-feira")
                        Spacer()
                        FaltaStepper(value: $materia.faltasTerca)
                    }
                }
                
                Section{
                    HStack{
                        Text("Quarta-feira")
                        Spacer()
                        FaltaStepper(value: $materia.faltasQuarta)
                    }
                }
                
                Section{
                    HStack{
                        Text("Quinta-feira")
                        Spacer()
                        FaltaStepper(value: $materia.faltasQuinta)
                    }
                }
                
                Section{
                    HStack{
                        Text("Sexta-feira")
                        Spacer()
                        FaltaStepper(value: $materia.faltasSexta)
                    }
                }
                
                Section{
                    HStack{
                        Text("Sábado")
                        Spacer()
                        FaltaStepper(value: $materia.faltasSabado)
                    }
                }
                
                
//                Button(action: {
//                    showManualControlModal = true
//                }){
//                    Text("Controle manual de faltas")
//                        .foregroundColor(.white)
//                        .frame(maxWidth: .infinity)
//                        .padding(.vertical, 12)
//                        .background(
//                            RoundedRectangle(cornerRadius: 8)
//                                .fill(Color(UIColor.systemBlue))
//                        )
//                }
//                .frame(maxWidth: .infinity)
//
//                .listRowInsets(EdgeInsets())
//                .listRowBackground(Color.clear)
                
                
                Button(action: {
                    modelContext.delete(materia)
                    try? modelContext.save()
                    dismiss()
                }){
                    Text("Excluir matéria")
                        .foregroundColor(.white)
                        .frame(maxWidth: 135)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(UIColor.systemRed), lineWidth: 2)
                        )
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 12)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                
                
            }//Fim do form
                
            .navigationTitle("Editar matéria")
            .navigationBarTitleDisplayMode(.inline)

            .toolbar{
                ToolbarItem(placement: .confirmationAction){
                    Button("Salvar"){
                        print("Salvar clicado")
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
            .sheet(isPresented: $showManualControlModal) {
                ManualControlModal()
                    
            }
            

        }//Fim navigation view
        
    }//Fim da Viewbody
        
}

//#Preview {
//    EditMateriaModal()
//}
