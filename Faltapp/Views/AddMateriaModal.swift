//
//  AddMateria.swift
//  Faltapp
//
//  Created by Leonel Ferraz Hernandez on 09/08/25.
//

import SwiftUI
import SwiftData


struct AddMateriaModal: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    var materia: Materia? = nil
    
    var isEditando: Bool { materia != nil }
    
    @State private var nome = ""
    
    //States
    @State private var faltasSegunda = 0
    @State private var faltasTerca = 0
    @State private var faltasQuarta = 0
    @State private var faltasQuinta = 0
    @State private var faltasSexta = 0
    @State private var faltasSabado = 0
    
    var limiteFaltas: Int {
        let soma = faltasSegunda + faltasTerca + faltasQuarta + faltasQuinta + faltasSexta + faltasSabado
        return soma * 2
    }

    @State private var showTip: Bool = !UserDefaults.standard.bool(forKey: "hasSeenAddTip")
    
    var AddMateria: (Materia) -> Void
    
    var body: some View {
        NavigationView {
            
            //Input do nome da matéria
        
                Form{
                    Section(header: Text("Nome da matéria")){
                        TextField("Insira aqui o nome da matéria", text: $nome)
                            .padding(.leading, 8)
                    }
                    .foregroundStyle(.white)
                    .padding(.leading, -16)
                    
                    
                    HStack{
                        Image(systemName: "info.circle")

                            .foregroundStyle(.blue)
                            .onTapGesture {
                                withAnimation{
                                    showTip.toggle()
                                }
                                if !showTip{
                                    UserDefaults.standard.set(true, forKey: "hasSeenAddTip")
                                }
                            }
                        Text("Informe quantos períodos de 50 minutos você tem em cada dia letivo, o app fará o resto.")
                    }
                    if showTip {
                            Section {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Como funciona o cálculo de créditos?")
                                        .fontWeight(.semibold)
                                    Text("Cada período equivale a 50 minutos de aula. Uma aula de 1h40 (como das 10h30 às 12h10) conta como 2 períodos de 50 minutos. Informe quantos períodos de 50 minutos você tem em cada dia, e o app faz o cálculo automaticamente.")
                                        .font(.caption)
                                }
                                .padding(.vertical, 4)
                            }
                            .listRowSeparator(.hidden)
                        }
                    
                    
                    
                    Section{
                        HStack{
                            Text("Segunda-feira")
                            Spacer()
                            FaltaStepper(value: $faltasSegunda)
                        }
                    }
                    
                    Section{
                        HStack{
                            Text("Terça-feira")
                            Spacer()
                            FaltaStepper(value: $faltasTerca)
                        }
                    }
                    
                    Section{
                        HStack{
                            Text("Quarta-feira")
                            Spacer()
                            FaltaStepper(value: $faltasQuarta)
                        }
                    }
                    
                    Section{
                        HStack{
                            Text("Quinta-feira")
                            Spacer()
                            FaltaStepper(value: $faltasQuinta)
                        }
                    }
                    
                    Section{
                        HStack{
                            Text("Sexta-feira")
                            Spacer()
                            FaltaStepper(value: $faltasSexta)
                        }
                    }
                    
                    Section{
                        HStack{
                            Text("Sábado")
                            Spacer()
                            FaltaStepper(value: $faltasSabado)
                        }
                    }
                    
                }
            //Fim vstack
//            .onTapGesture {
////                UIApplication.shared.dismissKeyboard()
//            }
            
            
            
            
            
            .navigationTitle("Adicionar matéria")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Adicionar") {
                        let materia = Materia(titulo: nome, maximoFaltas: limiteFaltas)
                        print("Criado")
//                        AddMateria(materia)
                        print(materia.titulo, materia.maximoFaltas)
                        modelContext.insert(materia)
                        try? modelContext.save()
                        dismiss()
                    }
                    .disabled(nome.isEmpty)
                    .foregroundStyle(nome.isEmpty ? Color.gray : Color.blue)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
        }
    }//Fim da View body
}

#Preview {
    AddMateriaModal{ _ in}
}

extension UIApplication{
    func dismissKeyboard(){
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
