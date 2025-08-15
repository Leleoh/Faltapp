//
//  MainTabView.swift
//  Faltapp
//
//  Created by Leonel Ferraz Hernandez on 07/08/25.
//

import SwiftUI

struct MainTabView: View {
    
    @State private var showAddMateriaModal: Bool = false
    @State private var showAddFaltaModal: Bool = false
    @State private var materias: [Materia] = []
    
    var body: some View {
        
        TabView {
            NavigationStack {
                MainView()
                    .navigationTitle(Text("Matérias"))
                    .toolbarBackgroundVisibility(.visible)
            }
            .tabItem {
                Image(systemName: "list.clipboard.fill")
                Text("Faltas")
            }
            
            NavigationStack {
                ConfigsView()
                    .navigationTitle(Text("Configurações"))
                    .toolbarBackgroundVisibility(.visible)
            }
            .tabItem {
                Image(systemName: "gearshape.2.fill")
                Text("Configurações")
            }
        }
        .sheet(isPresented: $showAddMateriaModal) {
            AddMateriaModal { materia in
                    // Atualize sua lista de matérias, por exemplo
                    print("Recebi matéria nova:", materia)
                    materias.append(materia)
                    showAddMateriaModal = false
                }
        }
    }
}

#Preview {
    MainTabView()
}
