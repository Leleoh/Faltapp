//
//  Data.swift
//  Faltapp
//
//  Created by Leonel Ferraz Hernandez on 16/08/25.
//

import SwiftUI
import SwiftData

struct Data: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var materias: [Materia]
    @State private var showConfirmation = false
    
    
    var body: some View {
       
        ZStack{
            
            Color(UIColor.backgroundsSecondary)
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Text("Aviso")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                
                Text("Os dados das suas matérias e faltas são armazenados apenas localmente no seu dispositivo. Caso você opte por ativar a sincronização automática dos tickets do RU, suas credenciais ficam salvas exclusivamente no Keychain do seu iPhone e são usadas apenas para consultar seu saldo no Portal da UFRGS.")
                    .padding(.top, 1)
                    .multilineTextAlignment(.leading)
        
                Spacer()
                
                Button(role: .destructive) { // botão vermelho
                    showConfirmation = true
                    } label: {
                        Text("Deletar todas as matérias")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(16)
                    }
                
                Spacer()
            }
            .padding(.top, 16)
            .padding(.horizontal, 16)
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .alert("Deseja realmente deletar todas as matérias?", isPresented: $showConfirmation) {
                    Button("Cancelar", role: .cancel) {}
                    Button("Deletar", role: .destructive) {
                        deleteAllMaterias()
                    }
                }
        
    }
    
    private func deleteAllMaterias() {
            for materia in materias {
                modelContext.delete(materia)
            }
            try? modelContext.save()
        }}

#Preview {
    Data()
}
