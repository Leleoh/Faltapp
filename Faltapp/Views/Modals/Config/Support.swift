//
//  Support.swift
//  Faltapp
//
//  Created by Leonel Ferraz Hernandez on 16/08/25.
//

import SwiftUI

//
//  Support.swift
//  Faltapp
//

import SwiftUI

struct Support: View {
    var body: some View {
        ZStack {
            Color(UIColor.backgroundsSecondary) // mantém fundo consistente com o app
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Título principal
                    Text("Suporte & Contato")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    // Seção de contato
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Entre em contato")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Você pode nos enviar um e-mail para reportar erros ou enviar sugestões:")
                            .font(.body)
                            .foregroundColor(.secondary)
                        
                        Text("leonel.hernandez@ufrgs.br")
                            .font(.body)
                            .foregroundColor(.blue)
                            .underline()
                            .onTapGesture {
                               
                                if let url = URL(string: "mailto:leonel.hernandez@ufrgs.br") {
                                    UIApplication.shared.open(url)
                                }
                            }
                    }
                    
                    Divider()
                    
                    // Seção de sugestões
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Sugestões e feedback")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Ajude o Faltapp a melhorar! Envie ideias e sugestões que faremos o possível para implementar.")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 32)
            }
        }
        
    }
}


#Preview {
    Support()
}
