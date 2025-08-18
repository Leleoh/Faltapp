//
//  About.swift
//  Faltapp
//
//  Created by Leonel Ferraz Hernandez on 16/08/25.
//

import SwiftUI

struct About: View {
    var body: some View {
        
        
        ZStack {
            Color(UIColor.backgroundsSecondary)
                .ignoresSafeArea()
            
            VStack(alignment: .leading){
                Text("Sobre o app")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("O Faltapp nasceu com o objetivo de ajudar estudantes a organizarem suas faltas, já que a universidade não oferece um sistema claro para isso e, quando existe, muitas vezes os professores não o atualizam.\nInspirado no aplicativo Faltômetro UFRGS, que conquistou muitos usuários, surgiu a necessidade de criar um aplicativo também para iOS, já que o Faltômetro está disponível apenas para Android.\n")
                    .multilineTextAlignment(.leading)
                
                Text("Importante")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("O Faltapp não tem nenhum vínculo com a UFRGS. Ele foi desenvolvido por um estudante, para ajudar outros estudantes.\nPor isso, o app não impede que você seja reprovado por faltas ele serve apenas para te ajudar a se organizar.\nUse-o com responsabilidade, faltar é sempre por sua conta e risco.")
                    .multilineTextAlignment(.leading)
                
                Spacer()
                Text("Desenvolvido por Leonel Ferraz")
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("V1.0")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
            }
            .padding(.horizontal)
        }
        }
}

#Preview {
    About()
}
