//
//  ContentView.swift
//  Faltapp
//
//  Created by Leonel Ferraz Hernandez on 06/08/25.
//

import SwiftUI
import SwiftData


struct MainView: View {
    
    @Environment(\.modelContext) var modelContext
    
    @State private var showAddMateriaModal: Bool = false
    @State private var showAddFaltaModal: Bool = false
//    @Binding var materias: [Materia]
    @Query var materias: [Materia]
    
    @State private var materiaSelecionada: Materia?
    
    
    
    var body: some View {
        
        VStack(spacing: 0){
            
            // MARK: Empty state
            if materias.isEmpty{
                VStack{
                    //Imagem do empty state
                    Image(systemName: "books.vertical.fill")
                        .resizable()
                        .frame(width: 62, height: 61)
                        .foregroundColor(Color(UIColor.tertiaryLabel))
                    
                    //Label empty
                    Text("Nenhuma matéria adicionada")
                        .fontWeight(.semibold)
                    
                    //Texto complementar
                    Text("Adicione uma matéria e ela será mostrada aqui")
                        .foregroundColor(Color(UIColor.secondaryLabel))
                        .padding(.top, 8)
                    
                    Button(action: {
                        showAddMateriaModal = true
                    }){
                        Text("Adicionar matéria")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 40)
                                    .fill(Color(UIColor.systemBlue))
                            )
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
                }
                .frame(maxWidth: .infinity, maxHeight:.infinity)
                .background(Color(UIColor.mainColorBG))
                .toolbarBackground(Color(UIColor.tabViewBG), for: .tabBar)
                .toolbarBackgroundVisibility(.visible, for: .tabBar)
            }//Fim do if
            else{
                ScrollView {
                    VStack(spacing: 16) {
                        // ✅ Iteramos pelos índices para poder modificar o array
                        ForEach(materias) { materia in
                            CardMateria(
                                materia: materia, progress: Double(materia.faltas) / Double(materia.maximoFaltas),
                                onAdicionarFalta: {novasDatas in 
                                    // Quando o botão no card é clicado, definimos a matéria a ser editada
                                    materia.datasFaltas = novasDatas
                                    try? modelContext.save()
                                }
                            )
                        }
                    }
                    .padding(.top, 32)
                    .padding(.horizontal, 8)
                }
                .background(Color(UIColor.systemBackground))
            }
        }
            
            
            
            
        .navigationTitle("Matérias")
        .toolbarBackground(Color(UIColor.tertiarySystemBackground), for: .navigationBar)
        .toolbarVisibility(.visible, for: .navigationBar)
        .toolbarBackground(Color(UIColor.tabViewBG), for: .tabBar)
        .toolbarBackgroundVisibility(.visible, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showAddMateriaModal = true
                } label: {
                    Image("AddMateria")
                        .resizable()
                        .frame(width: 34, height: 34)
                        .scaledToFit()
                }
            }
        }
        
        .sheet(isPresented: $showAddMateriaModal) {
            AddMateriaModal{ materia in
                modelContext.insert(materia)
                showAddMateriaModal = false
                
            }
        }
            
        }//Fim da some view
    }//Fim da view principal
    
    
//#Preview {
//    // Para o preview funcionar, criamos um "binding constante"
//    NavigationView {
//        MainView(materias: .constant([
//            Materia(titulo: "Exemplo 1", maximoFaltas: 20),
//            Materia(titulo: "Exemplo 2", maximoFaltas: 18)
//        ]))
//    }
//}
